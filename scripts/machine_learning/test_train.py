from multiprocessing import parent_process
import sys
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import cross_val_score, train_test_split

from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import (
    accuracy_score,
    precision_score,
    recall_score,
    f1_score,
    roc_auc_score,
)
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn import tree
from xgboost import XGBClassifier

from sklearn.model_selection import train_test_split
from sklearn.model_selection import TimeSeriesSplit
from sklearn import preprocessing

from sklearn.feature_selection import RFE
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif

from telegram import ParseMode
from tqdm import tqdm

import mlflow
import mlflow.sklearn
from google.cloud import bigquery
from google.oauth2 import service_account

import configparser
from pprint import pprint
import shap



def get_data_from_bigquery():
    credentials = service_account.Credentials.from_service_account_file("../../config/chessthesis_service_account.json")

    bqclient = bigquery.Client(credentials = credentials)

    # Download query results.
    query_string = """
    SELECT *
    FROM chess_thesis.games_with_features
    ORDER BY year, month, day ASC
    """

    dataframe = (
        bqclient.query(query_string)
        .result()
        .to_dataframe(
            # Optionally, explicitly request to use the BigQuery Storage API. As of
            # google-cloud-bigquery version 1.26.0 and above, the BigQuery Storage
            # API is used by default.
            create_bqstorage_client=True,
        )
    )

    X = dataframe.drop(["result"], axis=1)
    y = dataframe["result"]

    return X, y


def get_mlflow_ec2_ip():
    parser = configparser.ConfigParser()
    parser.read('../src/pipeline.ini')

    ec2_ip = parser.get("Amazonaws", "public_dns")

    return ec2_ip


def mlflow_log_parameters(model):
    parameter_dict = model.get_params()

    for key, value in parameter_dict.items():
        mlflow.log_param(key, value)


def mlflow_log_artifacts(X, model, log_shap_summary=True):
    """
    the output directory is prepared before logging:
    ├── output
    │   ├── data
    │   │   ├── data_sample.csv
    │   │   └── data_sample.html
    │   ├── images
    │   │   ├── gif_sample.gif
    │   │   └── image_sample.png
    │   ├── maps
    │   │   └── map_sample.geojson
    │   └── plots
    │       └── plot_sample.html
    """

    # if the logged artifact is a folder,
    # then it will also show as a folder in mlflow
    #mlflow.log_artifact("./output/plots")
    #mlflow.log_artifact("./output/data")

    if log_shap_summary:
        try:
            mlflow_log_shap_values(X, model)
        except:
            print("Couldn't save shap plot.")

    # Save sample data as an artifact
    mlflow_log_sample_data(X)


def mlflow_log_shap_values(X, model):
    # (this syntax works for XGBoost, LightGBM, CatBoost, and scikit-learn models)
    explainer = shap.TreeExplainer(model)

    # the SHAP explainer uses both X_train and X_test
    shap_values = explainer.shap_values(X)

    # show = False is required to properly save the file
    shap.summary_plot(shap_values, X, plot_type='bar', show=False)
    plt.savefig('shap_summary_plot.png')

    mlflow.log_artifact("./shap_summary_plot.png")
    print(mlflow.get_artifact_uri())


def mlflow_log_sample_data(X):
    """Saves the first 5 lines of the input dataframe as an artifact for the current MLFlow run.

    Args:
        X (pd.DataFrame): The dataset without the target variable.
    """
    save_sample_data(X)
    mlflow.log_artifact("./sample_data.csv")


def save_sample_data(df):
    sample = df.head(5)
    sample.to_csv('sample_data.csv')


def mlflow_enable_autolog(model_type):
    if model_type == "xgboost":
        mlflow.xgboost.autolog()
    elif model_type == "lightgbm":
        mlflow.lightgbm.autolog()
    else:
        mlflow.sklearn.autolog()


def mlflow_log_metrics(y_test, y_pred):
    accuracy = accuracy_score(y_test, y_pred)
    precision = precision_score(y_test, y_pred, average='micro')
    recall = recall_score(y_test, y_pred, average='micro')
    f1 = f1_score(y_test, y_pred, average='micro')
    #auc = roc_auc_score(y_test, y_pred, multi_class="ovr")

    mlflow.log_metric("accuracy", accuracy)
    mlflow.log_metric("precision", precision)
    mlflow.log_metric("recall", recall)
    mlflow.log_metric("f1", f1)
    #mlflow.log_metric("auc", auc)


def train_and_log_wfo_cv_xgboost(X, y, model_type = "xgboost"):
    """
        Trains an XGBoost model with Walk-forward optimization on the given dataset.
        After training, it logs the

    Args:
        X (pd.DataFrame): Dataset containing non-target features.
        y (pd.DataFrame): Dataset containing the target.
    """
    tscv = TimeSeriesSplit(gap=0, max_train_size=None, n_splits=3, test_size=None)

    model_dict = {
        "xgboost" : XGBClassifier(random_state=42),
        "knn" : KNeighborsClassifier(n_neighbors=4),
        "logreg": LogisticRegression(multi_class='ovr', random_state=42, solver='lbfgs', max_iter=1000),
        "decision_tree": tree.DecisionTreeClassifier(max_depth=100, random_state=42),
        "random_forest": RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
    }

    model = model_dict[model_type]

    scores = cross_val_score(model, X, y, cv=tscv)

    try:
        mlflow.log_metric("scores", scores)
    except:
        print("Couldnt track cross val scores.")

    mlflow.log_metric("mean_cv_score", scores.mean())
    mlflow.log_metric("mean_cv_deviation", scores.std())

    test_tscv = TimeSeriesSplit(gap=0, max_train_size=None, n_splits=2, test_size=None)
    all_splits = list(test_tscv.split(X, y))
    last_split_train, last_split_test = all_splits[1]

    X_train, X_test, y_train, y_test = X.iloc[last_split_train], X.iloc[last_split_test], y[last_split_train], y[last_split_test]

    # Do Recursive Feature Elimination
    #rfe = RFE(model, n_features_to_select=300, step=1)

    # in case of using RFE, do rfe.fit(X,y)
    model.fit(X_train, y_train)

    # Calculate predictions
    y_pred = model.predict(X_test)

    # Log metrics that describe model performance
    mlflow_log_metrics(y_test, y_pred)

    eval_data = X_test
    eval_data["result"] = y_test

    print(eval_data.shape)

    model_info = mlflow.sklearn.log_model(model, model_type)
    result = mlflow.evaluate(
        model_info.model_uri,
        data=eval_data,
        targets="result",
        model_type="classifier",
        dataset_name="chess-thesis",
        evaluator_config={
            "explainability_nsamples": 1000,
            "log_model_explainability": False
        }
    )

    return {
        'model': model,
        'model_type': model_type
    }


def train_and_log_xgboost(x_train, x_test, y_train, y_test):
    print("------ TRAINING XGBOOST ----------")
    xgb_classifier = XGBClassifier(random_state=42)
    xgb_classifier.fit(x_train, y_train)

    # Calculate predictions
    y_pred = xgb_classifier.predict(x_test)

    # Log metrics that describe model performance
    mlflow_log_metrics(y_test, y_pred)

    return {
        'model': xgb_classifier,
        'model_type': "xgboost"
    }


def preprocess_train_data(input_df):

    #df = input_df[["white_elo", "black_elo", "white_age", "black_age"]]
    input_df = input_df.drop(["eco"], axis=1)
    df = pd.get_dummies(input_df, columns=['white_title', 'black_title', 'white_elo_group_opening', 'black_elo_group_opening'])

    return df


def label_encode_target(y):
    encoded_y = y.replace('1-0', 0).replace('1/2-1/2', 1).replace('0-1', 2)
    print(encoded_y)

    return encoded_y


def rule_based_model(row):
    # Usage: df["pred_result"] = df.apply(rule_based_model, axis=1)

    if row["white_elo"] > row["black_elo"] + 50:
        return "1-0"
    elif row["white_elo"] > row["black_elo"]-50 and row["white_elo"] <= row["black_elo"]+50:
        return "1/2-1/2	"
    else:
        return "0-1"


def run_mlflow_training(model_type):

    X, y = get_data_from_bigquery()

    X = preprocess_train_data(X)
    y = label_encode_target(y)

    if model_type in ['knn', 'logreg', 'decision_tree', 'random_forest']:
        # if it's a KNN model, we need to standardize the values
        if model_type == 'knn':
            X = (X-X.mean())/X.std()

        X = X.fillna(0)

    mlflow_server_ip = get_mlflow_ec2_ip()
    # set registry URI i.e. where MLflow saves runs
    mlflow.set_tracking_uri(
        mlflow_server_ip
    )
    client = mlflow.tracking.MlflowClient(tracking_uri=mlflow_server_ip)

    mlflow.set_experiment("my-experiment")

    with mlflow.start_run():
        # Train the model to meet your specific needs
        print(mlflow.get_artifact_uri())

        model_dict = train_and_log_wfo_cv_xgboost(X, y, model_type)

        #model_dict = train_and_log_xgboost(X_train, X_test, y_train, y_test)
        model = model_dict["model"]

        # Enable auto logging for MLFlow
        # mlflow_enable_autolog(model_dict["model_type"])

        # Log model related parameters
        mlflow_log_parameters(model)
        mlflow.log_param("NUMBER_OF_FEATURES", len(X.columns.values))


        # Log artifacts connected to the current run (sample data, plots etc.)
        mlflow_log_artifacts(X, model, log_shap_summary=True)


if __name__ == '__main__':
    model_types = ["knn", "logreg", "random_forest", "decision_tree", "xgboost"]

    for type in model_types:
        try:
            run_mlflow_training(type)
        except Exception as e:
            print(f"Couldnt train {type} model. Error: {e}")
            continue

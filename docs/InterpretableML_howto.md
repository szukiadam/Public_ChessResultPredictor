# Interpretable ML models HowTo

[Source](https://christophm.github.io/interpretable-ml-book)

## SHAP - SHapley Additive exPlanations

1. Explanations for individual predictions
1. SHAP feature importance
   1. The idea behind SHAP feature importance is simple: Features with large absolute Shapley values are important.
   2. Alternative to [permutation feature importance](https://christophm.github.io/interpretable-ml-book/feature-importance.html#feature-importance)
1. SHAP Summary plot
   1. Combines feature importance with feature effects
   2. Shows indications of the relationship between the value of a feature and the impact on the prediction. But to see the exact form of the relationship, we have to look at SHAP dependence plots.
1. SHAP dependence plots
   1. Pick a feature
   2. For each data instance, plot a point with the **feature value** on the x-axis and the corresponding **Shapley value** on the y-axis.
   3. Alternative to [PDP](https://christophm.github.io/interpretable-ml-book/pdp.html#pdp) and [ALE](https://christophm.github.io/interpretable-ml-book/ale.html#ale)
1. Clustering Shapley Values
   1. SHAP clustering works by clustering the Shapley values of each instance
   1. Not sure how this one helps or why this is useful right now
1. Advantages
   1. solid theoretical foundation (game theory)
   2. fairly distributed predictions
   3. constrastive explanations (compare to the average prediction)
   4. SHAP connects LIME and Shapley values
   5. Fast implementation for tree-based models
2. Disadvantages
   1. KernelSHAP is slow
   2. KernelSHAP ignores feature dependence (e.g. correlated features)
   3. TreeSHAP can produce unintuitive feature attributions
      1. With the change in the value function, features that have no influence on the prediction can get a TreeSHAP value different from zero.
   4. Can be misinterpreted
   5. Possible to create intentionally misleading interpretations

## [Partial Dependence Plot (PDPD)](https://christophm.github.io/interpretable-ml-book/pdp.html)

- *Python packages: scikit-learn, PDPBox*

1. Shows the marginal effect **one or two features** have on the predicted outcome of a machine learning model
2. An **assumption** of the PDP is that the **features in C are not correlated with the features in S**. If this assumption is violated, the averages calculated for the partial dependence plot will include data points that are very unlikely or even impossible
3. In practice, the set of features S usually only contains one feature or a maximum of two, because one feature produces 2D plots and two features produce 3D plots. Everything beyond that is quite tricky.
4. Advantages
   1. Intuitive plots
   2. Clear interpretation: The partial dependence plot shows how the average prediction in your dataset changes when the j-th feature is changed
   3. Easy to implement
   4. Causal interpretation.
      1. !! **The relationship is causal for the model** – because we explicitly model the outcome as a function of the features – **but not necessarily for the real world** !!
5. Disadvantages
   1. Max of 2 features
   2. Some PD plots do not show the feature distribution. This might lead to incorrect interpretations.
   3. **Assumption of independence**.
      1. It is assumed that the feature(s) for which the partial dependence is computed are not correlated with other features.
      2. One solution to this problem is **Accumulated Local Effect plots** or short ALE plots that work with the conditional instead of the marginal distribution.
   4. Heterogeneous effects might be hidden. In short, the effects of a feature might be cancelled out, resulting in 'no effect'.
      1. By plotting the individual conditional expectation curves instead of the aggregated line, we can uncover heterogeneous effects.

# [Feature interaction](https://christophm.github.io/interpretable-ml-book/interaction.html)

1. “The whole is greater than the sum of its parts”
2. One way to estimate the interaction strength is to measure how much of the variation of the prediction depends on the interaction of the features. **This is called H-statistic.**
3. One-to-all, one-to-one interactions
4. Advantages
   1. Underlying theory
   2. Meaningful interpretation - The interaction is defined as the **share of variance that is explained by the interaction**.
   3. Dimensionless - comparable across features and even across models
   4. Detects all kinds of interactions
   5. Possibility to analyse higher interactions (strength btw 3 or more features)
5. Disadvantages
   1. Computationally expensive
   2. Estimates have a certain variance -> results can be unstable
   3. It is unclear whether an interaction is significantly greater than 0
   4. It is difficult to say when the H-statistic is large enough for us to consider an interaction “strong”
   5. The H-statistic tells us the strength of interactions, but it does not tell us how the interactions look like.
   6. We might integrate over feature combinations that are very unlikely
from cgitb import small
from posixpath import split
from re import S
import subprocess
import configparser
from pprint import pprint

def send_one_file_to_all_ec2(path_to_pem, send_file_path, num_of_instances):
    instances = get_ec2_instances(num_of_instances)

    for i in instances:
        subprocess.run(f"scp -i {path_to_pem} {send_file_path} ec2-user@{i}:~/.", shell=True)


def get_ec2_instances(num_instances):
    parser = configparser.ConfigParser()
    parser.read('pipeline.ini')

    instances = []
    for i in range(1,num_instances+1):
        instances.append(parser.get("Amazonaws", f"instance_{i}"))
    return instances

def send_file_to_ec2(send_file_path, instance_dns, path_to_pem = '../../config/chess_thesis.pem'):
    subprocess.run(f"scp -i {path_to_pem} {send_file_path} ec2-user@{instance_dns}:~/.", shell=True)


def split_file_to_parts(big_file_path, lines_per_file = 1200):
    """Splits a file into smaller parts

    Args:
        big_file_pat (string, required): The path to the big file, which we will split.
        lines_per_file (integer, optional): Describes how many lines (positions) should a file contain.
                                        Defaults to 1200, which takes ~1 hour to be analysed.
    """
    smallfiles = []
    smallfile = None

    with open(big_file_path) as bigfile:
        for lineno, line in enumerate(bigfile):
            if lineno % lines_per_file == 0:
                if smallfile:
                    smallfile.close()
                    smallfiles.append(small_filename)
                small_filename = 'positions_{}.epd'.format(lineno + lines_per_file)
                smallfile = open(small_filename, "w")
            smallfile.write(line)
        if smallfile:
            smallfile.close()
            smallfiles.append(small_filename)


    return smallfiles

def split_positions(num_files, original_file_path):
    """
    Splits the file (full of positions) into smaller files.
    Used for splitting analysis positions into as many files as many EC2 instances we have.

    Args:
        num_files (_type_): Describes the number of files we want to split into.
        original_file_path (_type_): Path of the one big file we will split.
    """

    num_lines = sum(1 for line in open(original_file_path))

    lines_per_file = round(num_lines / num_files)+1

    split_files = split_file_to_parts(original_file_path, lines_per_file)

    return split_files


def split_and_send_files_to_vms(big_file, num_instances):
    """Sends the files to the corresponding EC2 instances.
    """

    instance_list = get_ec2_instances(num_instances)
    split_files = split_positions(len(instance_list), big_file)


    if len(instance_list) != len(split_files):
        print("Error: Number of instancesand files doesn't match. Process interrupted.")
        print(f"Number of instances: {len(instance_list)}, number of files: {len(split_files)}")
        return None

    for idx, instance in enumerate(instance_list):
        send_file_to_ec2(split_files[idx], instance)


def download_file_from_ec2(instance_dns, pem_filepath, download_file_path):
    subprocess.run(f"scp -i {pem_filepath} ec2-user@{instance_dns}:{download_file_path} ../../data/downloaded_data/{instance_dns}{download_file_path}", shell=True)

if __name__  == '__main__':

    #send_one_file_to_all_ec2("../../config/chess_thesis.pem", "stockfish_14.1_linux_x64_popcnt", 11)

    instances = get_ec2_instances(11)
    for i in instances:
        download_file_from_ec2(
            i,
            "../../config/chess_thesis.pem",
            "analysed_positions.csv"
            )

    #split_and_send_files_to_vms('positions.epd', 11)

    #split_positions(10, 'test_split.epd')

    #send_file_to_ec2("../../config/chess_thesis.pem", "./test.txt","ec2-user@ec2-3-70-189-190.eu-central-1.compute.amazonaws.com")

    #send_files_to_vms(10)


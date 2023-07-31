import os

# BEGIN CONFIG
FOLDER_PATH = "./results"
# END CONFIG

def parse_output_file(filename):
    output_data = {}

    with open(filename, 'r') as file:
        for line in file:
            key, value = line.strip().split()
            output_data[key] = value

    # calculate throughput
    num_runs = int(output_data['runs'])
    real_time_str = output_data['real']
    real_time_minutes, real_time_seconds = map(float, real_time_str.strip('ms').split('m'))
    real_time_seconds_total = real_time_minutes * 60 + real_time_seconds
    output_data['real_sec'] = real_time_seconds_total
    output_data['throughput'] = num_runs / real_time_seconds_total

    return output_data

def find_txt_files_in_folder(FOLDER_PATH):
    txt_files = [file for file in os.listdir(FOLDER_PATH) if file.endswith(".txt")]
    return txt_files

if __name__ == "__main__":
    txt_files = find_txt_files_in_folder(FOLDER_PATH)

    output_list = [(txt_file, parse_output_file(os.path.join(FOLDER_PATH, txt_file))) for txt_file in txt_files]

    print("Output Data List:")
    print(output_list)

import instances
import os

def get_configs():
    global config_paths
    config_paths = []

    inst_list = list(instances.inst_setup)

    i=1
    while i<=instances.inst_number:
        new_list = inst_list
        new_list = [w.replace('*', str(i)) for w in inst_list]
        config_path = instances.mc_path + "\\instances\\" + "".join(new_list) + "\\.minecraft\\config\\standardoptions.txt"
        config_paths.append(config_path)
        i += 1
    
    return config_paths

get_configs()

prompt = "which settings file would you like to use, typed in the format rsg.txt\n\n"
user = input(prompt)
cwd = os.getcwd()
options_path = cwd + "\\" + user

for i in range(len(config_paths)):
    options = open(config_paths[i], "w+")
    options.write(options_path)

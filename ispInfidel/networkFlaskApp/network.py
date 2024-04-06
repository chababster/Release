import speedtest
import sys

source = sys.argv[1]
s = speedtest.Speedtest(source_address=source)
s.get_best_server()
s.download()
s.upload()

results_dict = s.results.dict()
for key in results_dict.keys():
    if(key == "client" or key == "server"):
        print(key)
        for subKeys in results_dict[key].keys():
            print("\t%s\t%s" % (subKeys, results_dict[key][subKeys]) )
    else:
        print("%s\t%s" % (key, results_dict[key]) )

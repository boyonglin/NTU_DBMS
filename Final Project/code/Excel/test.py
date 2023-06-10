import sys

# Retrieve the arguments
arg1 = sys.argv[1]
arg2 = sys.argv[2]
arg3 = sys.argv[3]
arg4 = sys.argv[4]

output = "Column Range: " + arg1 + " to " + arg2 + "\n"
output += "Data Range: " + arg3 + " to " + arg4 + "\n"


with open(r"D:\NTU BEBI\111-2 Course\資料庫系統\NTU_DBMS\Final Project\code\Excel\test.txt","w") as file:
    file.write(output)
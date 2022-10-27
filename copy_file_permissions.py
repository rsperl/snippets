import os, stat
st = os.stat(src_file_name)
mode = stat.S_IMODE(st.st_mode)
os.chmod(dest_file_name, mode)
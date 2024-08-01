import pandas as pd
import hashlib
import glob
import os
import sys
#import pdb

#pdb.set_trace()


darshan_app_list = (['e3sm','lmp_summit', 'RAPTOR'])
#dir_dest_path = os.getenv('DEST_DIR_PATH')
dir_dest_path = '/lustre/orion/proj-shared/stf218/ketan/testoutdir/'
#dir_dest_path = '/mnt/bb/ketan2/testoutdir/'

#Darshan hashing functions
def md5_hash(s: str): 
    return hashlib.md5(s.encode('utf-8')).hexdigest()
    
def hash_detail_df(df_detail):
    for col_name in ['uid','filename','darshanid']:
        if col_name == 'darshanid':
            df_detail = df_detail.drop(columns=[col_name])
        else:
            df_detail[col_name] = df_detail[col_name].astype('str').apply(md5_hash)
    return df_detail

def hash_total_df(df_total):
    for col_name in ['uid','exe','darshanid','job_prefix']:
        try:
            if col_name in ['darshanid','job_prefix']:
                df_total = df_total.drop(columns=[col_name])
            else:
                df_total[col_name] = df_total[col_name].astype('str').apply(md5_hash)
        except:
            continue
    return df_total


def get_job_ids(curr_month, curr_year, app_name):
    df_app = pd.DataFrame()
    #dir_src_path = os.getenv('SRC_DIR_PATH')
    #dir_src_path = '/lustre/orion/proj-shared/stf218/data/lake/summit_darshan_processed/'
    dir_src_path = '/mnt/bb/ketan2/lustre/orion/proj-shared/stf218/data/lake/summit_darshan_processed/'
    data_total_path = (f'{dir_src_path}'
                       f'{curr_year}/{curr_month}/*/darshan_total/*.csv')
    list_total_dshn_files = glob.glob(data_total_path)
    for f_ in list_total_dshn_files:
        try:
            df = pd.read_csv(f_)#.columns#['exe']
            #df = df.loc[:,['darshanid','exe', 'jobid']]
    
            df = df[df['exe'].str.contains(app_name)]
            curr_date_ = f_.split('/')[-3].zfill(2)
            df['date'] = f'{str(curr_year).zfill(2)}-{str(curr_month).zfill(2)}-{curr_date_}'
            df_app = pd.concat([df_app, df], axis=0)
        except:
            continue
        if df_app.shape[0] > 1000:
            break
    return df_app


def get_darshan_detail(df_jobs):
    """ """
    #dir_src_path = os.getenv('SRC_DIR_PATH')
    #dir_src_path = '/lustre/orion/proj-shared/stf218/data/lake/summit_darshan_processed/'
    dir_src_path = '/mnt/bb/ketan2/lustre/orion/proj-shared/stf218/data/lake/summit_darshan_processed/'
    #dir_dest_path = os.getenv('DEST_DIR_PATH')
    data_detail_path = (f'{dir_src_path}')
    data_detail_dest_path = (f'{dir_dest_path}')
    for index, row in df_jobs.iterrows():
        
        row_year = row['date'].split('-')[0]
        row_month = str(int(row['date'].split('-')[1]))
        row_day = str(int(row['date'].split('-')[2]))
        row_jobid = str(row['jobid'])
        data_job_detail_path_ = (f"{data_detail_path}{row_year}/{row_month}/{row_day}/"
                                 f"darshan_detail/{row_jobid}.*")

        detail_parquet_files = glob.glob(data_job_detail_path_)
        
        file_seq = 0
        for f_ in detail_parquet_files:
            data_detail_file_dest = (f'{data_detail_dest_path}{row_year}/{row_month}/{row_day}/'
                                     f'{row_jobid}-{file_seq}.parquet')
            
            df_loop_detail = pd.read_parquet(f_)
            try:
                df_loop_detail = hash_detail_df(df_loop_detail)
            except:
                continue
            dest_dir_name_ = os.path.dirname(data_detail_file_dest)
            if not os.path.exists(dest_dir_name_):
                os.makedirs(dest_dir_name_)
            df_loop_detail.to_parquet(data_detail_file_dest)
            file_seq += 1
    return 0


curr_month = sys.argv[1]
curr_year = sys.argv[3]

app_name = darshan_app_list[int(sys.argv[2])]

df = get_job_ids(curr_month, curr_year, app_name)

df_get_detail = df[~df.duplicated(['jobid','date'])]
ff_ = get_darshan_detail(df_get_detail)

total_hashed_df = hash_total_df(df_get_detail)
data_total_dest_path = (f'{dir_dest_path}/darshan_total/') 
if 'date' in total_hashed_df.columns:
    total_hashed_df = total_hashed_df.drop(columns=['date'])
    saved_total_file = f"{data_total_dest_path}{app_name}-{curr_year}-{str(curr_month).zfill(2)}.parquet"
    total_hashed_df.to_parquet(saved_total_file)

print(f"Done-{curr_year}-{curr_month}-{app_name}-{int(sys.argv[2])}")


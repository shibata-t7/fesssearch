#!/bin/bash

# 設定ファイル
. ./getjson_config.txt

# 初期設定
if test `hostname` = "stg-search01" || test `hostname` = "search01" ; then
    diins_proxy=""
else
    diins_proxy="-x proxy.gtd.dnp.co.jp:8080"
fi
str=',"paginationKey" :'
pagenation_flg="true";
pagenation_key="";
tmp_dir=`mktemp -d getkii_tmp.XXXXXXXXXX`;
cd ${tmp_dir};
tmp_file=`mktemp tmp_json.XXXXXXXXXX`;
# i=0;

# mBaaSの指定BucketよりObjectに格納されたJSONを一括取得
while [ "$pagenation_flg" = "true" ]
do
query='{"bucketQuery":{"clause":{"type":"all"}}'${pagenation_key}'}';
kii_response=`curl -X POST \
  ${diins_proxy} \
  -H "Authorization: Bearer $access_token" \
  -H "X-Kii-AppID: ${app_id}" \
  -H "X-Kii-AppKey: ${app_key}" \
  -H "Content-Type: application/vnd.kii.QueryRequest+json" \
  -s "https://${kii_domain}/api/apps/${app_id}/buckets/${bucket_name}/query" \
  -d "${query}"`;
pagenation_flg=`echo $kii_response | jq 'has("nextPaginationKey")'`;
pagenation_key=$str`echo $kii_response | jq '.nextPaginationKey'`;

# echo i is ${i};
# echo pagenation_key is ${pagenation_key};
# echo pagenation_flg is ${pagenation_flg};
# i=`expr $i + 1`
echo $kii_response | jq '.results' >> tmp_${tmp_file};
done

# テンポラリファイルの削除
#rm -rf ${tmp_dir};
date;

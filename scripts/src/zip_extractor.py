import requests, zipfile, io, time

def download_twic(start_id, end_id):
    headers = {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:55.0) Gecko/20100101 Firefox/55.0'
    }

    for curr_id in range(start_id, end_id+1):
        time.sleep(5)
        current_url = f"https://theweekinchess.com/zips/twic{curr_id}g.zip"
        r = requests.get(current_url, headers=headers)
        z = zipfile.ZipFile(io.BytesIO(r.content))
        z.extractall("./pgns")

download_twic(1156, 1408)

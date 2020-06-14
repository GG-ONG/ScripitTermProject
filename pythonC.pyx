import json
import requests
import smtplib
import folium
import webbrowser
import numpy as np

from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
from email.mime.text import MIMEText
from tkinter import *
from matplotlib import pyplot as plt







def telegram():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']

    cityname = "도시이름 :" + city
    wslc = "날씨 상태 : " + weather_status
    tlc = "온도 : " + str(temperature)
    hlc = "습도 : " + str(humidity)
    wlc = "바람 세기 : " + str(wind_speed)

    token = "1206680949:AAFv4zWsk-cOIemuLOoBGS7S8bGi_4wTLyE"
    url = 'https://api.telegram.org/bot{}/getUpdates'.format(token)
    response = json.loads(requests.get(url).text)
    url = 'https://api.telegram.org/bot{}/sendMessage'.format(token)
    chat_id = response["result"][-1]["message"]["from"]["id"]
    text = response["result"][-1]["message"]["text"]
    msg = text

    if text == "선택한 도시 날씨":
        msg = cityname + "\n" + wslc + "\n" + tlc + "\n" + hlc + "\n" + wlc

    requests.get(url, params={"chat_id": chat_id, "text": msg})


def location():
    url = 'https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAuV8ksn8Hz7genu2V7Iz1EsCpAe2DKSMI'
    data = {
        'considerIp': True,
    }
    result = requests.post(url, json=data)
    result_json = result.json()
    window = Tk()
    window.geometry("700x10")
    window.title(result.text)
    lat = (result_json['location']['lat'])
    lng = (result_json['location']['lng'])
    m = folium.Map(location=[lat, lng], zoom_start=15)
    folium.Marker(
        location=[lat, lng],
        popup="You are Here!",
        tooltip="You are here!",
        icon=folium.Icon(color='red', icon='star')).add_to(m)

    m.save("현재위치위도경도.html")

    filepath = "현재위치위도경도.html"

    webbrowser.open_new_tab(filepath)

def picked():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()
    lat = output['coord']['lat']
    lon = output['coord']['lon']

    m = folium.Map(location=[lat, lon], zoom_start=15)
    folium.Marker(
        location=[lat, lon],
        popup="You are Here!",
        tooltip="You are here!",
        icon=folium.Icon(color='red', icon='star')).add_to(m)

    m.save("선택한도시위도경도.html")

    filepath = "선택한도시위도경도.html"

    webbrowser.open_new_tab(filepath)


def saveinfo():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    temp_min = output['main']['temp_min']
    temp_max = output['main']['temp_max']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']
    lat = output['coord']['lat']
    lon = output['coord']['lon']

    cityname = "도시이름 : " + city
    wslc = "날씨 상태 : " + weather_status
    tlc = "온도 : " + str(temperature)
    tmin = "최저 온도 : " + str(temp_min)
    tmax = "최고 온도 : " + str(temp_max)
    hlc = "습도 : " + str(humidity)
    wlc = "바람 세기 : " + str(wind_speed)
    lat_LoN = "위도 경도 : " + str(lat) + "," + str(lon)


    f = open("날씨정보.txt", 'w')
    texts = [cityname, wslc, tlc, tmin, tmax, hlc, wlc,lat_LoN]
    for text in texts:
        msg = text
        f.write(msg + "\n")
    f.close()


def chart():


    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    temp_min = output['main']['temp_min']
    temp_max = output['main']['temp_max']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']


    labels = ['Current']
    x = np.arange(len(labels))
    width = 0.35

    fig, ax = plt.subplots()
    rects1 = ax.bar(x + width/0.5, temperature, width, label="AvgTemp")
    rects2 = ax.bar(x - width/0.5, temp_min, width, label="MinTemp")
    rects3 = ax.bar(x + width/1, temp_max, width, label="MaxTemp")
    rects4 = ax.bar(x - width/1, humidity, width, label="Humidity")
    rects5 = ax.bar(x + width/150, wind_speed, width, label="WindSpeed")





    ax.set_title(city + " Weather : " + weather_status)
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.legend()

    def autolabel(rects):
        for rect in rects:
            height = rect.get_height()
            ax.annotate('{}'.format(height),
                        xy=(rect.get_x()+rect.get_width() / 2, height),
                        xytext=(0,3),
                        textcoords="offset points",
                        ha='center', va='bottom')

    autolabel(rects1)
    autolabel(rects2)
    autolabel(rects3)
    autolabel(rects4)
    autolabel(rects5)

    fig.tight_layout()

    plt.show()





def sendmail():
    msg = MIMEMultipart()

    text = '첨부파일 확인'
    contentPart = MIMEText(text)
    msg.attach(contentPart)

    etcFileName = '날씨정보.txt'
    with open(etcFileName, 'rb') as etcFD:
        etcPart = MIMEApplication(etcFD.read())
        etcPart.add_header('Content-Disposition', 'attachment', filename=etcFileName)
        msg.attach(etcPart)

    s = smtplib.SMTP('smtp.gmail.com', 587)
    s.starttls()
    s.login("tjddyddl93@gmail.com", "wmayettrcaauvtfq")

    msg['Subject'] = '선택한 도시 날씨 정보'
    s.sendmail("tjddyddl93@gmail.com", "tjddyddl93@gmail.com", msg.as_string())

    s.quit()


def weather():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    temp_min = output['main']['temp_min']
    temp_max = output['main']['temp_max']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']
    lat = output['coord']['lat']
    lon = output['coord']['lon']



    weather_status_label.configure(text="날씨 상태 : " + weather_status)
    temperature_label.configure(text="온도 : " + str(temperature))
    temp_min_label.configure(text="최저 온도 : " + str(temp_min))
    temp_max_label.configure(text="최고 온도 : " + str(temp_max))
    humidity_label.configure(text="습도 : " + str(humidity))
    wind_speed_label.configure(text="바람 세기 : " + str(wind_speed))
    coord_label.configure(text="위도 경도 : " + str(lat)+","+str(lon))



window = Tk()
window.title("도시 날씨 정보")
window.geometry("1024x768")

city_name_list = ["Seoul", "Tokyo", "Beijing", "Washington", "London", "Berlin", "Rome", "Madrid", "Paris",
                  "Siheung-si","Rheine"]

city_listbox = StringVar(window)
city_listbox.set("도시를 선택하세요")
option = OptionMenu(window, city_listbox, *city_name_list)
option.grid(row=2, column=1, padx=150, pady=10)

b1 = Button(window, text="확인", width=15, command=weather)
b1.grid(row=2, column=0, padx=150)
b2 = Button(window, text="메일보내기", width=15, command=sendmail)
b2.grid(row=24, column=0, padx=150)
b2 = Button(window, text="저장하기", width=15, command=saveinfo)
b2.grid(row=25, column=0, padx=150)
b4 = Button(window, text="챗봇", width=15, command=telegram)
b4.grid(row=30, column=0, padx=150)
b5 = Button(window, text='차트로보기', width=15, command=chart)
b5.grid(row=35, column=0, padx=150)
b6 = Button(window, text="현재위치 위도 경도", width=15, command=location)
b6.grid(row=40, column=0, padx=150)
b7 = Button(window, text="선택한 도시로 바로가기", width=25, command=picked)
b7.grid(row=4, column=1, padx=150)


weather_status_label = Label(window, font=("times", 15, "bold"))
weather_status_label.grid(row=10, column=1)

temperature_label = Label(window, font=("times", 15, "bold"))
temperature_label.grid(row=12, column=1)

temp_min_label = Label(window, font=("times", 15, "bold"))
temp_min_label.grid(row=14, column=1)

temp_max_label = Label(window, font=("times", 15, "bold"))
temp_max_label.grid(row=16, column=1)

humidity_label = Label(window, font=("times", 15, "bold"))
humidity_label.grid(row=18, column=1)

wind_speed_label = Label(window, font=("times", 15, "bold"))
wind_speed_label.grid(row=20, column=1)

coord_label = Label(window, font=("times", 15, "bold"))
coord_label.grid(row=24, column=1)

window.mainloop()

import json
import requests
import smtplib
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

    if text =="선택한 도시 날씨":
        msg = cityname +"\n" + wslc + "\n" + tlc + "\n" + hlc +"\n"+ wlc

    requests.get(url, params= {"chat_id" : chat_id, "text" : msg})


def location():


    url = 'https://www.googleapis.com/geolocation/v1/geolocate?key=AIzaSyAuV8ksn8Hz7genu2V7Iz1EsCpAe2DKSMI'
    data = {
        'considerIp': True,
    }
    result = requests.post(url,data)
    window=Tk()
    window.geometry("700x10")
    window.title(result.text)


def saveinfo():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']

    cityname = "도시이름 : " + city
    wslc="날씨 상태 : " + weather_status
    tlc="온도 : " + str(temperature)
    hlc="습도 : " + str(humidity)
    wlc="바람 세기 : " + str(wind_speed)

    f = open("날씨정보.txt",'w')
    texts = [cityname,wslc,tlc,hlc,wlc]
    for text in texts:
        msg = text
        f.write(msg+"\n")
    f.close()


def chart():
    city = city_listbox.get()
    url = "https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res = requests.get(url)
    output = res.json()

    weather_status = output['weather'][0]['description']
    temperature = output['main']['temp']
    humidity = output['main']['humidity']
    wind_speed = output['wind']['speed']


    wslc = weather_status
    tlc = temperature
    hlc = humidity
    wlc = wind_speed

    y = [tlc,hlc,wlc]

    plt.plot(["Temperature", "Humidity" ,"Wind_Speed"],y)
    plt.title(city + " Weather_status : " + wslc)
    plt.show()





def sendmail():

    msg = MIMEMultipart()

    text ='첨부파일 확인'
    contentPart = MIMEText(text)
    msg.attach(contentPart)

    etcFileName ='날씨정보.txt'
    with open(etcFileName, 'rb') as etcFD:
        etcPart = MIMEApplication(etcFD.read())
        etcPart.add_header('Content-Disposition', 'attachment', filename=etcFileName)
        msg.attach(etcPart)

    s = smtplib.SMTP('smtp.gmail.com', 587)
    s.starttls()
    s.login("tjddyddl93@gmail.com","wmayettrcaauvtfq")


    msg['Subject'] = '선택한 도시 날씨 정보'
    s.sendmail("tjddyddl93@gmail.com", "tjddyddl93@gmail.com", msg.as_string())

    s.quit()



def weather():
    city=city_listbox.get()
    url="https://openweathermap.org/data/2.5/weather?q={}&appid=439d4b804bc8187953eb36d2a8c26a02".format(city)
    res=requests.get(url)
    output=res.json()

    weather_status=output['weather'][0]['description']
    temperature=output['main']['temp']
    humidity=output['main']['humidity']
    wind_speed=output['wind']['speed']

    weather_status_label.configure(text="날씨 상태 : "+weather_status)
    temperature_label.configure(text="온도 : "+str(temperature))
    humidity_label.configure(text="습도 : "+str(humidity))
    wind_speed_label.configure(text="바람 세기 : "+str(wind_speed))





window=Tk()
window.title("도시 날씨 정보")
window.geometry("400x350")

city_name_list=["Seoul","Tokyo","Beijing","Washington","London","Berlin","Rome","Madrid","Paris","Siheung-si"]

city_listbox=StringVar(window)
city_listbox.set("도시를 선택하세요")
option=OptionMenu(window,city_listbox, *city_name_list)
option.grid(row=2, column=2, padx=150, pady=10)

b1=Button(window,text="확인", width=15, command=weather)
b1.grid(row=5, column=2, padx=150)
b2=Button(window,text="메일보내기", width=15, command=sendmail)
b2.grid(row=20, column=2, padx=150)
b2=Button(window,text="저장하기", width=15, command=saveinfo)
b2.grid(row=25, column=2, padx=150)
b3=Button(window,text="챗봇", width=15, command=telegram)
b3.grid(row=30, column=2, padx=150)
b4=Button(window,text='차트로보기', width=15, command=chart)
b4.grid(row=32, column=2, padx=150)
b5=Button(window,text="현재위치 위도 경도", width=15, command=location)
b5.grid(row=34, column=2, padx=150)

weather_status_label=Label(window,font=("times",15,"bold"))
weather_status_label.grid(row=10,column=2)

temperature_label=Label(window,font=("times",15,"bold"))
temperature_label.grid(row=12,column=2)

humidity_label=Label(window,font=("times",15,"bold"))
humidity_label.grid(row=14,column=2)

wind_speed_label=Label(window,font=("times",15,"bold"))
wind_speed_label.grid(row=16,column=2)

window.mainloop()







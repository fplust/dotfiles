#! python
from urllib.request import urlopen
from urllib.error import URLError
from json import loads

def getWeatherCondition(city):
    apikey = '266610bc75ef6511e88da1b92efebb4b'
    url = "http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s" % (city, apikey)
    try:
        req = urlopen(url)
    except URLError:
        return None
    return loads(req.read().decode('utf8'))

# city = "Changsha,cn"
city = "Changsha,cn"
weather = getWeatherCondition(city)
temper = int(weather['main']['temp'] - 273.15)
iconid = weather['weather'][0]['icon']
dayicondict = {'01':' ', '02':' ', '03':' ', '04':' ', '09':' ',
        '10':' ', '11':' ', '13':' ', '50':' '}
nighticondict = {'01':' ', '02':' ', '03':' ', '04':' ', '09':' ',
        '10':' ', '11':' ', '13':' ', '50':' '}
if iconid[2] == 'd':
    icon = dayicondict[iconid[0:2]]
else:
    icon = nighticondict[iconid[0:2]]
print(icon+str(temper)+'℃ ', end = '')

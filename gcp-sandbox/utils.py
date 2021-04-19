import math
from math import pi, atan2


def cal_distance(latlon_1=(35.562479, 139.716073),
                 latlon_2=(35.278699, 139.670040)):

    POLE_RADIUS = 6356752.314245                  # 極半径
    EQUATOR_RADIUS = 6378137.0                    # 赤道半径

    # 緯度経度をラジアンに変換
    lat1, lon1 = math.radians(latlon_1[0]), math.radians(latlon_1[1])
    lat2, lon2 = math.radians(latlon_2[0]), math.radians(latlon_2[1])

    lat_difference = lat1 - lat2       # 緯度差
    lon_difference = lon1 - lon2       # 経度差
    lat_average = (lat1 + lat2) / 2    # 平均緯度

    e2 = (math.pow(EQUATOR_RADIUS, 2) - math.pow(POLE_RADIUS, 2)) \
        / math.pow(EQUATOR_RADIUS, 2)  # 第一離心率^2

    w = math.sqrt(1 - e2 * math.pow(math.sin(lat_average), 2))

    m = EQUATOR_RADIUS * (1 - e2) / math.pow(w, 3)  # 子午線曲率半径

    n = EQUATOR_RADIUS / w                         # 卯酉線曲半径

    distance = math.sqrt(math.pow(m * lat_difference, 2)
                         + math.pow(n * lon_difference * math.cos(lat_average), 2))  # 距離計測

    print(distance / 1000)


def circles_intersection_area(P1, r1, P2, r2):
    x1, y1 = P1
    x2, y2 = P2

    dd = (x1 - x2)**2 + (y1 - y2)**2

    if (r1 + r2)**2 <= dd:
        return 0.0

    if dd <= (r1 - r2)**2:
        return pi*min(r1, r2)**2

    p1 = (r1**2 - r2**2 + dd)
    p2 = (r2**2 - r1**2 + dd)

    S1 = r1**2 * atan2((4*dd*r1**2 - p1**2)**.5, p1)
    S2 = r2**2 * atan2((4*dd*r2**2 - p2**2)**.5, p2)
    S0 = (4*dd*r1**2 - p1**2)**.5 / 2

    return S1 + S2 - S0


"""
l = []
for i in range(12):
    print(i/2)
    ans = circles_intersection_area((0, 0), 3, (0, i/2), 3)/(pi * (3**2))
    l.append(ans)

s = pd.Series(l)
s.index = [i/2 for i in range(12)]
s.plot.bar()
"""

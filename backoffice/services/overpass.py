import requests
import time
import math

class Overpass:
    def __init__(self, osmId: int):
        self.osmId = osmId
        self.overpassData = self.__getOverpassDataByOsmId()
        self.nodes = self.__getNodes()
        self.ways = self.__getWays()
        self.geometries = self.__getGeometries()

    def __getOverpassDataByOsmId(self):
        time.sleep(1)
        query = f"[out:json][timeout:25];(rel(id:{self.osmId}););(._;>;);out geom;>;"
        response = requests.get('https://overpass-api.de/api/interpreter', params={'data': query})
        return response.json().get('elements', [])

    def __getNodes(self):
        return [element for element in self.overpassData if element['type'] == 'node']

    def __getWays(self):
        return [element for element in self.overpassData if element['type'] == 'way']
    
    def __getGeometries(self):
        points = []
        node_map = {node['id']: node for node in self.nodes}
        for way in self.ways:
            way_nodes = way['nodes']
            way_points = []
            for i in range(len(way_nodes) - 1):
                start_node = node_map.get(way_nodes[i])
                end_node = node_map.get(way_nodes[i + 1])
                if start_node and end_node:
                    way_points.append({
                        'lat': start_node['lat'],
                        'lon': start_node['lon'],
                        'query': f"{start_node['lat']},{start_node['lon']}",
                        'distance': 0,
                        'elevation': None
                    })
                    way_points.append({
                        'lat': end_node['lat'],
                        'lon': end_node['lon'],
                        'query': f"{end_node['lat']},{end_node['lon']}",
                        'distance': 0,
                        'elevation': None
                    })

            points.append(way_points)

        return points
    
    def getStartingPoint(self):
        return self.ways[0]['nodes'][0]
    
    def getEndingPoint(self):
        return self.ways[-1]['nodes'][-1]

    def getElevation(self):
        chunk_size = 100
        chunked_geometries = []

        for sublist in self.geometries:
            for i in range(0, len(sublist), chunk_size):
                chunked_geometries.append(sublist[i:i + chunk_size])

        print(f"Total chunks: {len(chunked_geometries)}")

        for chunk in chunked_geometries:
            print(f"Processing chunk {chunked_geometries.index(chunk) + 1}/{len(chunked_geometries)}")
            time.sleep(1)
            query = '|'.join([node['query'] for node in chunk])
            response = requests.get(f"https://api.opentopodata.org/v1/srtm30m?locations={query}")
            data = response.json()
            for i, node in enumerate(chunk):
                node['elevation'] = data['results'][i]['elevation']

        return self.geometries
    
    def getAltitude(self):
        altitude_positive = 0
        altitude_negative = 0

        for way in self.geometries:
            for i in range(len(way) - 1):
                first_value = way[i]['elevation']
                second_value = way[i + 1]['elevation']

                if first_value is not None and second_value is not None:
                    difference = second_value - first_value

                    if difference > 0:
                        altitude_positive += difference
                    elif difference < 0:
                        altitude_negative += abs(difference)
                else:
                    print('Elevation not found')

        return altitude_positive, altitude_negative
    
    def getDistance(self):
        distance = 0
        for way in self.geometries:
            for i in range(len(way) - 1):
                first_value = way[i]
                second_value = way[i + 1]

                R = 6371.0
                lat_rad = math.radians(first_value['lat'])
                lon_rad = math.radians(second_value['lat'])
                delta_lat = math.radians(second_value['lat'] - first_value['lat'])
                delta_lon = math.radians(second_value['lon'] - first_value['lon'])
                a = math.sin(delta_lat / 2.0) ** 2 + math.cos(lat_rad) * math.cos(lon_rad) * math.sin(delta_lon / 2.0) ** 2
                c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
                
                way[i + 1]['distance'] = R * c
                distance += R * c

        return f"{distance:.2f}"
    
    def getDuration(self, distance: float, speed: float):
        return int(distance / speed * 60 * 60)
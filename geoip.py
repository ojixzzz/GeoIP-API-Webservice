import GeoIP
import falcon

class GeoipResource:
    def on_get(self, req, resp):
        ipaddr = req.get_param('ipaddr')
        if ipaddr is None or ipaddr == "":
            ipaddr = '8.8.8.8'

        gi = GeoIP.new(GeoIP.GEOIP_MEMORY_CACHE)
        resp.body = gi.country_code_by_addr(ipaddr) or 'xx'
        resp.status = falcon.HTTP_200

app = falcon.API()
app.add_route('/apis/geoip', GeoipResource())
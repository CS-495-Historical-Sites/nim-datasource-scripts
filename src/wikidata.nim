import std/[json, httpclient, tables]


type WikidataHttpClient* = object
    httpClient: HttpClient
    endpoint: string = "https://www.wikidata.org/w/rest.php/wikibase/v0"


type WikidataItemResponse* = JsonNode

proc getItem*(c: WikidataHttpClient, itemId: string): WikidataItemResponse =
    let uri = c.endpoint & "/entities/items/" & item_id
    return c.httpClient.getContent(uri).parseJson

proc newWikidataHttpClient*(authToken: string): WikidataHttpClient =
    var tbl = newTable[string, seq[string]]()
    var headers = HttpHeaders(table: tbl)
    var client = newHttpClient()
    client.headers = headers

    client.headers["Authorization"] = "Bearer " & authToken
    return WikidataHttpClient(httpClient: client)




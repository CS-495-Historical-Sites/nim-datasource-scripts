import std/[json, options, strutils, httpclient]

import location
import wikidata
import wikipedia


proc fetchWikidataInfo(client: WikidataHttpClient,
        itemid: string): WikidataItemResponse =
    return client.getItem(itemid)

proc fetchWikidataInfo(authToken: string, itemids: seq[string]): seq[Location] =
    var locations: seq[Location] = @[]
    let client = newWikidataHttpClient(authToken)
    var wikipediaClient = newHttpClient()
    for id in itemids:
        let response = fetchWikidataInfo(client, id)
        let locationOpt = response.toLocation
        
        if locationOpt.isNone:
            continue
        
        var location = locationOpt.get
        if location.wikipedia_link.isSome:
            let link = location.wikipedia_link.get
            let longDescription = getWikipediaArticleSummary(wikipediaClient, link)
            location.long_description = longDescription

                
        locations.add(location)

        if locations.len mod 50 == 0:
            echo locations.len
    return locations



when isMainModule:
    let secrets = readFile("secrets.json").parseJson
    let accessToken = secrets["access_token"].getStr
    let queryText = readFile("query.json")

    let locationsToQuery = parseJson(queryText)

    var ids: seq[string] = @[]
    let begin = 60000
    let pull = 10000
    var counter = 0
    for previousQueryResult in locationsToQuery:
        counter += 1
        if counter < begin:
            continue
        let link = previousQueryResult["item"].getStr.split("/")
        let id = link[link.len - 1]

        ids.add(id)
        if ids.len >= pull:
            break

    let locations = fetchWikidataInfo(accessToken, ids)

    let dump = %locations
    let fileName = "results:" & $begin & "-" & $(begin + pull) & ".json"
    writeFile(fileName, $dump)





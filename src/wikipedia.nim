import std/[httpclient, json, strutils, uri, options]



proc getWikipediaArticleSummary*(client: HttpClient, wikipediaLink: string): Option[string] =
    let splitLink = wikipediaLink.split("/wiki")
    let articleName = splitLink[splitLink.len - 1]
    let endpoint = "https://en.wikipedia.org/api/rest_v1/page/summary/" & articleName[1..articleName.len - 1]
    try:
        let response = client.getContent(decodeUrl(endpoint)).parseJson
        let summary = response["extract"].getStr
        return some(summary)
    except HttpRequestError as e:
        echo "Exception: " & e.msg
        return none(string)


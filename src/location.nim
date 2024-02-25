import std/[json, options]

import wikidata

type
  LatLong* = object
    latitude: float
    longtitude: float

  Location* = object
    name*: string
    short_description*: Option[string]
    long_description*: Option[string]
    coordinates*: LatLong
    wikipedia_link*: Option[string]
    wikidata_image_name*: string

proc getName(node: WikidataItemResponse): Option[string] =
  let labels = node["labels"]
  if not labels.contains("en"):
    return none(string)

  return labels["en"].getStr.some



proc getShortDescription(node: WikidataItemResponse): Option[string] =
  if not node["descriptions"].contains("en"):
    return none(string)

  return some(node["descriptions"]["en"].getStr)



proc getWikipediaPage(node: WikidataItemResponse): Option[string] =
  if not node.contains("sitelinks"):
    return none(string)

  let siteLinks = node["sitelinks"]
  if not siteLinks.contains("enwiki"):
    return none(string)

  return some(sitelinks["enwiki"]["url"].getStr)

proc getCoordinates(node: WikidataItemResponse): Option[LatLong] =
  var location_info = node["statements"]["P625"][0]["value"]
  if not location_info.contains("content"):
    return none(LatLong)

  location_info = location_info["content"]
  let lat = location_info["latitude"].getFloat
  let long = location_info["longitude"].getFloat

  return some(LatLong(latitude: lat, longtitude: long))

proc getImageName(node: WikidataItemResponse): Option[string] =
  let statements = node["statements"]
  if not statements.contains("P18"):
    return none(string)

  let image = statements["P18"][0]["value"]["content"].getStr
  return some(image)

proc toLocation*(node: WikidataItemResponse): Option[Location] =
  let name = node.getName
  if name.isNone:
    return none(Location)
  let shortDesc = node.getShortDescription
  let wikipediaPage = node.getWikipediaPage
  let coordinates = node.getCoordinates
  if coordinates.isNone:
    return none(Location)

  let imageName = node.getImageName
  if imageName.isNone:
    return none(Location)

  return some(Location(
    name: name.get,
    short_description: shortDesc,
    long_description: some(""),
    coordinates: coordinates.get,
    wikipedia_link: wikipediaPage,
    wikidata_image_name: imageName.get
  ))





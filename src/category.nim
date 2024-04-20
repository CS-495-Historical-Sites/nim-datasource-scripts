import std/strutils

type
  CategoryKind = enum
    ARCHITECTURE, ENTERTAINMENT_RECREATION, EXPLORATION_SETTLEMENT,
    HEALTH_MEDICINE, INDUSTRY, SOCIAL_HISTORY, EDUCATION, BLACK,
    COMMERCE, HISTORIC, MILITARY, PREHISTORIC, MARITIME_HISTORY, ETHNIC_HERITAGE,
    COMMUNITY_PLANNING_DEVELOPMENT, ECONOMICS, PHILOSOPHY,
    POLITICS_GOVERNMENT, COMMUNICATIONS, AGRICULTURE, EUROPEAN, TRANSPORTATION,
    ENGINEERING, RELIGION, LANDSCAPE_ARCHITECTURE, SCIENCE, ART, LAW,
    PERFORMING_ARTS, ARCHEOLOGY, NATIVE_AMERICAN, LITERATURE, CONSERVATION, OTHER, ASIAN,
     PACIFIC_ISLANDER, HISPANIC, INVENTION


  Category* = object
    case kind*: CategoryKind
    of HISTORIC:
      historicValue: string
    of ETHNIC_HERITAGE:
      heritageValue: string
    of ARCHEOLOGY:
        archeologyValue: string
    else:
      discard

proc toCatKind(s: string): CategoryKind =
  case s
  of "ARCHITECTURE": return ARCHITECTURE
  of "ENTERTAINMENT/RECREATION": return ENTERTAINMENT_RECREATION
  of "EXPLORATION_SETTLEMENT": return EXPLORATION_SETTLEMENT
  of "EXPLORATION/SETTLEMENT": return EXPLORATION_SETTLEMENT    
  of "HEALTH_MEDICINE": return HEALTH_MEDICINE
  of "INDUSTRY": return INDUSTRY
  of "SOCIAL HISTORY": return SOCIAL_HISTORY
  of "EDUCATION": return EDUCATION
  of "BLACK": return BLACK
  of "COMMERCE": return COMMERCE
  of "MILITARY": return MILITARY
  of "PREHISTORIC": return PREHISTORIC
  of "MARITIME HISTORY": return MARITIME_HISTORY
  of "COMMUNITY PLANNING AND DEVELOPMENT": return COMMUNITY_PLANNING_DEVELOPMENT
  of "PHILOSOPHY": return PHILOSOPHY
  of "ECONOMICS": return ECONOMICS
  of "POLITICS/GOVERNMENT": return POLITICS_GOVERNMENT
  of "COMMUNICATIONS": return COMMUNICATIONS
  of "AGRICULTURE": return AGRICULTURE
  of "EUROPEAN": return EUROPEAN
  of "TRANSPORTATION": return TRANSPORTATION
  of "ENGINEERING": return ENGINEERING
  of "RELIGION": return RELIGION
  of "HEALTH/MEDICINE": return HEALTH_MEDICINE
  of "LANDSCAPE ARCHITECTURE": return LANDSCAPE_ARCHITECTURE
  of "SCIENCE": return SCIENCE
  of "ART": return ART
  of "LAW": return LAW
  of "PERFORMING ARTS": return PERFORMING_ARTS
  of "ARCHEOLOGY": return ARCHEOLOGY
  of "NATIVE AMERICAN": return NATIVE_AMERICAN
  of "LITERATURE": return LITERATURE
  of "CONSERVATION": return CONSERVATION
  of "OTHER": return OTHER
  of "ASIAN": return ASIAN
  of "PACIFIC-ISLANDER": return PACIFIC_ISLANDER
  of "EXPLORATION/SETTLEMEN": return EXPLORATION_SETTLEMENT
  of "HISPANIC": return HISPANIC
  of "INVENTION": return INVENTION
  of "OTHER-ETHNIC": return ETHNIC_HERITAGE
  of "AMERICAN INDIAN": return NATIVE_AMERICAN
  else: 
    if s.startsWith("HISTORIC"):
      return HISTORIC
    if s.startsWith("ETHNIC HERITAGE"):
      return ETHNIC_HERITAGE
    if s.startsWith("ARCHEOLOGY"):
      return ARCHEOLOGY
    else:
      echo "Invalid category: ", s
      quit(QuitFailure)

proc toCategory*(s: string): Category =
  var cat = Category(kind: toCatKind(s))

  if cat.kind == HISTORIC:
    let historyType = s.split(" - ")[1]
    cat.historicValue = historyType
  if cat.kind == ETHNIC_HERITAGE:
    if not s.contains("-"):
      cat.heritageValue = ""
      return cat
    let heritageType = s.split("-")[1]
    cat.heritageValue = heritageType

  if cat.kind == ARCHEOLOGY:
    if not s.contains("-"):
      cat.archeologyValue = ""
      return cat
    let archeologyType = s.split("-")[1]
    cat.archeologyValue = archeologyType

  return cat
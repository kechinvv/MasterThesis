#set document(title: "Thesis Title", author: "Your Name")


#import "settings.typ": settings

#show: settings

#include "parts/shorts.typ"
#include "parts/terminology.typ"
#include "parts/intro.typ"
#include "parts/lit_review.typ"
#include "parts/selection.typ"
#include "parts/design.typ"
#include "parts/realization.typ"
#include "parts/results.typ"
#include "parts/conclusion.typ"

= Cписок использованных источников <nonumber>

#bibliography(
  "bib.bib",
  title: none,
  style: "gost-r-705-2008-numeric",
)







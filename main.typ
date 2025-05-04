#set document(title: "Thesis Title", author: "Your Name")



#import "settings.typ": settings

// У typst проблема, что он не умеет делать отступ на первом абзаце
// приходится явно выставлять его у каждого первого абзаца, т.е после заголовка
#import "utils.typ": fix-par
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

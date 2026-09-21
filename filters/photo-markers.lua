-- 1. Replace each image with a visible marker line (PhotoNote style).
--    Pandoc would otherwise drop photos into InDesign at raw pixel size
--    (a phone photo arrives ~56 inches wide) anchored inside the text.
-- 2. Turn [[wikilinks]] between entries into cross-reference markers
--    (XRef character style) so you can swap in page numbers during layout.

local function marker(src, cap)
  local name = (src:match("([^/\\]+)$") or src):gsub("%%20", " ")
  local text = "PHOTO → " .. name
  if cap ~= "" then text = text .. "  |  " .. cap end
  return pandoc.Div({pandoc.Para(pandoc.Inlines(text))}, {["custom-style"] = "PhotoNote"})
end

function Figure(fig)
  local src, cap = nil, pandoc.utils.stringify(fig.caption.long or {})
  fig:walk({ Image = function(i) src = src or i.src end })
  if src then return marker(src, cap) end
end

function Para(p)
  if #p.content == 1 and p.content[1].t == "Image" then
    local i = p.content[1]
    return marker(i.src, pandoc.utils.stringify(i.caption))
  end
end

function Link(l)
  if l.title == "wikilink" then
    local label = pandoc.utils.stringify(l.content)
    return pandoc.Span(pandoc.Inlines("→ " .. label), {["custom-style"] = "XRef"})
  end
end

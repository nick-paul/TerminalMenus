"""

    RadioMenu

A menu that allows a user to select a single option from a list.

# Sample Output

```julia
julia> request(RadioMenu(options, pagesize=4))
Choose your favorite fruit:
^  grape
   strawberry
 > blueberry
v  peach
Your favorite fruit is blueberry!
```

"""
mutable struct RadioMenu <: AbstractMenu
    options::Array{String,1}
    pagesize::Int
    pageoffset::Int
    selected::Int
end


"""

    RadioMenu(options::Array{String,1}; pagesize::Int=10)

Create a RadioMenu object. Use `request(menu::RadioMenu)` to get user input.
`request()` returns an `Int` which is the index of the option selected by the
user.

# Arguments

  - `options::Array{String, 1}`: Options to be displayed
  - `pagesize::Int=10`: The number of options to be displayed at one time, the menu will scroll if length(options) > pagesize
"""
function RadioMenu(options::Array{String,1}; pagesize::Int=10)
    length(options) < 1 && error("RadioMenu must have at least one option")

    # if pagesize is -1, use automatic paging
    pagesize = pagesize == -1 ? length(options) : pagesize
    # pagesize shouldn't be bigger than options
    pagesize = min(length(options), pagesize)
    # after other checks, pagesize must be greater than 1
    pagesize < 1 && error("pagesize must be >= 1")

    pageoffset = 0
    selected = -1 # none

    RadioMenu(options, pagesize, pageoffset, selected)
end



# AbstractMenu implementation functions
# See AbstractMenu.jl
#######################################

options(m::RadioMenu) = m.options

cancel(m::RadioMenu) = m.selected = -1

function pick(menu::RadioMenu, cursor::Int)
    menu.selected = cursor
    return true #break out of the menu
end

function writeLine(buf::IOBuffer, menu::RadioMenu, idx::Int, cursor::Bool, term_width::Int)
    cursor_len = length(CONFIG[:cursor])
    # print a ">" on the selected entry
    cursor ? print(buf, CONFIG[:cursor]) : print(buf, repeat(" ", cursor_len))
    print(buf, " ") # Space between cursor and text

    line = replace(menu.options[idx], "\n", "\\n")
    line = trimWidth(line, term_width, !cursor, cursor_len)

    print(buf, line)
end

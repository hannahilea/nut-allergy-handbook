using Pkg
Pkg.activate(@__DIR__)
using Dates
using CSV
using DataFrames
using Downloads: download

const SITE_DIR = joinpath(@__DIR__, "..")
const SITE_INDEX_TEMPLATE = joinpath(@__DIR__, "index.template.html")

function get_table_html(df)
    str = """
          <table>
                    <thead>
                        <tr>
                        {{ TABLE_HEAD }}
                        </tr>
                    </thead>
                    <tbody>
                    {{ TABLE_ROWS }}
                    </tbody>
                </table>
                """

    # Table head...
    rows_str = join(["<td>" * v * "</td>\n" for v in names(df)], "")
    str = replace(str, "{{ TABLE_HEAD }}" => rows_str)

    # Table body...
    rows_str = map(eachrow(df)) do entry
        row_str = ["<td>" * v * "</td>\n" for v in values(entry)]
        replace!(row_str, missing => "<td></td>\n")
        return "<tr>\n" * join(row_str, "") * "</tr>\n"
    end
    return str = replace(str, "{{ TABLE_ROWS }}" => join(rows_str, "\n"))
end

function wrap_in_details_block(summary, content)
    return """
           <details><summary>$summary</summary>
               $content
           </details>
           """
end


function generate_index(entries_df; overwrite_existing=false, template=SITE_INDEX_TEMPLATE)
    outfile = joinpath(SITE_DIR, "index.html")
    if !overwrite_existing && isfile(outfile)
        @warn "Output file already exists; not overwriting: $outfile"
        return nothing
    end
    index_str = read(template, String)

    data = select(entries_df,
                  :Classification,
                  Symbol("Name of place") => :Place,
                  Symbol("Google maps link") => ByRow(str -> "<a href=\"$str\">[link]</a>") => :Link,
                  :Comments => ByRow(str -> ismissing(str) ? "" : str) => :Details,
                  Symbol("Timestamp") => ByRow(str -> Dates.format(Date(first(split(str, " ")), dateformat"m/d/yyyy"), dateformat"uu yyyy")) => Symbol("Last checked"))

    out_str = ""
    for gdf in groupby(data, :Classification)
        title = first(gdf.Classification)
        out_str = get_table_html(select(gdf, Not(:Classification)))
        template_key = replace(uppercase(title), " " => "_")
        index_str = replace(index_str, "{{ $template_key }}" => out_str)
        index_str = replace(index_str, "{{ $(template_key)_COUNT }}" => nrow(gdf))
    end
    write(outfile, index_str)

    try
        run(`prettier $(outfile) --write --print-width 360`)
    catch
        @warn "Prettier not installed OR current html errors"
    end

    return nothing
end

function download_data!(data_path, id)
    url = "https://docs.google.com/spreadsheets/d/$(id)/export?format=csv"
    io = IOBuffer()
    download(url, io)
    str = String(take!(io))
    write(data_path, str)
    return nothing
end

# Thanks, https://discourse.julialang.org/t/how-to-best-store-and-access-credentials-in-julia/54997/12 !
function load_secrets(filename="secrets.env")
    isfile(filename) || return
    i = 0
    for line in eachline(filename)
        var, val = strip.(split(line, "="))
        ENV[var] = val
        i += 1
    end
    println("\t$i secret(s) loaded")
end

# Run from commandline? 
if abspath(PROGRAM_FILE) == @__FILE__
    data_path = joinpath(SITE_DIR, "data.csv")
    if "--download" in ARGS
        @info "...downloading data..."
        load_secrets()
        id = get(ENV, "GOOGLE_SHEET_ID", missing)
        download_data!(data_path, id)
    else 
        @info "Using pre-downloaded data..."
    end

    @info "...generating index.html..."
    entry_list = CSV.read(data_path, DataFrame)
    generate_index(entry_list; overwrite_existing=true)

    @info "Complete!"
    return nothing
end

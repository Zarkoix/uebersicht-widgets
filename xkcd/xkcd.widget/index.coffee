
command: "curl --silent http://xkcd.com/info.0.json"

# Set the refresh frequency (milliseconds) to every 6 hours
refreshFrequency: 21600000

# Render the output.
render: (output) -> """
  <div id='container'>
  <div>
"""
update: (output, domEl) ->
  xkcd = JSON.parse(output)
  container = $(domEl).find('#container')
  content =
    """
    <h2>#{xkcd.title}</h2>
    <p>#{xkcd.alt}</p>
    <img src="#{xkcd.img}"/>
    """
  $(container).html content

# CSS Style
style: """
  padding:0px
  right: 5px
  bottom: 5px
  background: rgba(255,255,255,0.3)
  border-radius: 20px
  display: flex
  flex-wrap: wrap
  width: 30em

  h2
    font-family: 'Open Sans', sans-serif;
    color: black
    text-align: center
    margin: 0px

  p
    font-family: 'Open Sans', sans-serif
    color: rgba(#000, .85)
    text-align: center
    margin-bottom: 2px
    margin-top: 0px
    word-wrap: break-word
    width: auto

  img
    width: 29em
    margin: 1em 0.5em


"""

afterRender: (domEl) ->
  $(domEl).on 'click', '#container', => @run "last=$(curl --silent http://xkcd.com/info.0.json | sed -e 's/[{}]/''/g' | awk -v k=\"text\" '{n=split($0,a,\",\"); for (i=1; i<=n; i++) print a[i]}' | grep '\"num\":' | sed 's/:/ /1' | awk -F \" \" '{ print $2 }') && newid=$((RANDOM%$last+1)) && curl --silent http://xkcd.com/$newid/info.0.json", (err, output) ->
    xkcd = JSON.parse(output)
    container = $(domEl).find('#container')
    content =
      """
      <h2>#{xkcd.title}</h2>
      <p>#{xkcd.alt}</p>
      <img src="#{xkcd.img}"/>
      """
    $(container).html content

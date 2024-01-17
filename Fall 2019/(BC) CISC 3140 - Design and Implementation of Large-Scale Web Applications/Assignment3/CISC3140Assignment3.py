import urllib.request
import json
import webbrowser


'''Amara Auguste's CISC 3140 Assignment 3: Part 1: html file to display NASA Astronomy Picture of the Day.'''

pageTemplate = '''
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Astronomy Picture of the Day
</title> 
<!-- gsfc meta tags -->
<meta name="orgcode" content="661">
<meta name="rno" content="phillip.a.newman">
<meta name="content-owner" content="Jerry.T.Bonnell.1">
<meta name="webmaster" content="Stephen.F.Fantasia.1">
<meta name="description" content="A different astronomy and space science
related image is featured each day, along with a brief explanation.">
<!-- -->
<meta name=viewport content="width=device-width, initial-scale=1">
<meta name="keywords" content="ngc6960, supernova remnant, pickering's triangle, witch's broom">
<!-- -->
<script language="javascript" id="_fed_an_ua_tag"
src="//dap.digitalgov.gov/Universal-Federated-Analytics-Min.js?agency=NASA">

var link=urllib.request.urlopen(decodeapod['url']).read()
</script>

</head>

<body BGCOLOR="#F4F4FF" text="#000000" link="#0000FF" vlink="#7F0F9F"
alink="#FF0000">

<center>
<h1> Astronomy Picture of the Day </h1>
<p>

<a>Discover the cosmos!</a>
Each day a different image or photograph of our fascinating universe is
featured, along with a brief explanation written by a professional astronomer.
<p>

<br> 
<a href= {link}>
<IMG SRC= {link}
alt="See Explanation.  Clicking on the picture will download
the highest resolution version available." style="max-width:100%"></a>

</center>
</body>
</html>

'''

## Define APOD
apodurl = 'https://api.nasa.gov/planetary/apod?'
mykey = 'api_key=DEMO_KEY'     ## your key goes in place of DEMO_KEY

## Call the webservice
apodurlobj = urllib.request.urlopen(apodurl + mykey)

## read the file-like object
apodread = apodurlobj.read()

## decode json to python data structure
decodeapod = json.loads(apodread.decode('utf-8'))

## display our pythonic data
print("\n\nConverted python data")
print(decodeapod)


def main():    
    link=decodeapod['url']
    contents = pageTemplate.format(**locals())   
    browseLocal(contents)

def strToFile(text, filename):
    """Write a file with the given name and the given text."""
    output = open(filename,"w")
    output.write(text)
    output.close()

def browseLocal(webpageText, filename='CISC3140Assignment3.html'):
    '''Start your webbrowser on a local file containing the text
    with given filename.'''
    import webbrowser, os.path
    strToFile(webpageText, filename)
    webbrowser.open("file:///" + os.path.abspath(filename)) 

main()
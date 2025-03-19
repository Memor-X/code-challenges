var site = "aoc"

function escapeRegEx(str){
	return str.replace(/[-\/\\^$*+?.()|[\]{}]/g,'\\$&')
}

function fetchTag(str,tag)
{
	startTag = tag.substring(0,tag.length-1)
	endTag = tag.slice(0, 1) + "/" + tag.slice(1);
	startIndex = str.indexOf(startTag);
	endIndex = str.indexOf(endTag,startIndex+1);
	extratedTag = str.substring(startIndex, endIndex+endTag.length)

	return extratedTag
}

var descSelectors = {
	"codewars":".description.h-full",
	"aoc":".day-desc",
	"leetcode":"#f35c77c6-df7c-2ee4-bd92-e4d04f6b10dc"
}
var nodeRemovals = {
	"codewars":['pre[style="display: none;"]'],
	"aoc":[],
	"leetcode":[]
}
var tagReplacement = {
	"<em>":"**",
	"</em>":"**",
	
	"<p>":"\n",
	"</p>":"\n",
	"<b>":"**",
	"</b>":"**",
	"<strong>":"**",
	"</strong>":"**",
	"<i>":"*",
	"</i>":"*",
	"<code>":"`",
	"</code>":"`",
	"<ul>":"",
	"</ul>":"",
	"<li>":"- ",
	"</li>":"",
	"<hr>":"------------------------------",
	"<pre>":"",
	"</pre>":"",
	"<div>":"",
	"</div>":"",
	"<span>":"",
	"</span>":"",
	"<h1>":"# ",
	"<h2>":"## ",
	"<h3>":"### ",
	"<h4>":"#### ",
	"</h1>":"",
	"</h2>":"",
	"</h3>":"",
	"</h4>":"",
}

var markdown = ""

var desc = document.querySelector(descSelectors[site])

if(nodeRemovals[site].length > 0)
{
	for(var i = 0; i <= nodeRemovals[site].length-1; i++)
	{
		removeCode = desc.querySelectorAll(nodeRemovals[site][i])
		if(removeCode.length > 0)
		{
			for(var j = 0; j <= removeCode.length-1; j++)
			{
				removeCode[j].remove()
			}
		}
	}
}

markdown = desc.innerHTML

var tags = Object.keys(tagReplacement)
for(var i = 0; i <= tags.length-1; i++)
{
	regex = new RegExp(escapeRegEx(tags[i]),"g")
	while((markdown.match(regex) || []).length > 0)
	{
		console.log("in while loop for "+tags[i]+" | matches left = "+(markdown.match(regex) || []).length)
		markdown = markdown.replace(tags[i],tagReplacement[tags[i]])
	}
}

var startTag = '<a '
regex = new RegExp(escapeRegEx(startTag),"g")
while((markdown.match(regex) || []).length > 0)
{
	aTag = fetchTag(markdown,"<a>")
	console.log("in while loop for "+aTag+" | matches left = "+(markdown.match(regex) || []).length)

	tagSplit = aTag.split('href="')
	tagSplit = tagSplit[1].split('"')
	href = tagSplit[0]

	tagSplit = aTag.split('>')
	tagSplit = tagSplit[1].split('<')
	linkText = tagSplit[0]
	linkMarkdown = "["+linkText+"]("+href+")"

	markdown = markdown.replace(aTag,linkMarkdown)
}

var startTag = '<svg'
regex = new RegExp(escapeRegEx(startTag),"g")
while((markdown.match(regex) || []).length > 0)
{
	svgTag = fetchTag(markdown,"<svg>")
	console.log("in while loop for "+svgTag+" | matches left = "+(markdown.match(regex) || []).length)

	markdown = markdown.replace(svgTag,"")
}

tags = ["<span ", "<div ", "<code= ","<strong "]

for(var i = 0; i <= tags.length-1; i++)
{
	regex = new RegExp(escapeRegEx(tags[i]),"g")
	while((markdown.match(regex) || []).length > 0)
	{
		console.log("in while loop for "+tags[i]+" | matches left = "+(markdown.match(regex) || []).length)
		startIndex = markdown.indexOf(tags[i]);
		endIndex = markdown.indexOf(">",startIndex+1);
		extratedTag = markdown.substring(startIndex, endIndex+1)
		markdown = markdown.replace(extratedTag,"")
	}
}

/*regex = new RegExp(escapeRegEx("\n\n"),"g")
while((markdown.match(regex) || []).length > 0)
{
	console.log("in while loop for "+'\n\n'+" | matches left = "+(markdown.match(regex) || []).length)
	markdown = markdown.replace("\n\n","\n")
}*/

console.log(markdown)
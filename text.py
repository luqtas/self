import re, sys

tags = []
tsearch = []

if __name__ == "__main__":
    lenght = len(sys.argv) - 1
    for o in range(lenght):
        o = o + 1
        tsearch.append(str(sys.argv[o]))

# needs to run through all MD files we have in /logs...
with open('/home/luqtas/Desktop/logs/330.md', 'r') as file:
    data = file.read()

def processor(result, db):
    result = re.findall(r"\[(.*?)\]", db)
    # then we go looping through the array to find for "," and make it unique items
    for n in range(len(result)):
        if n == 0:
            xxx = (str(result[0]))
            continue
        slow = "," + str(result[n])
        xxx = str(xxx + slow)
    result = [x.strip() for x in xxx.split(',')]
    for x in range(len(result)):
        result.append(str(result[0]))
        result.pop(0)
    result = list(set(result)) # remove duplicates
    return result

tags = processor(tags, data)

search = set()
for p in re.split(r'(?:\r\n?|\n){2,}', data): # https://stackoverflow.com/questions/66917980/only-scrape-paragraphs-containing-certain-words
    z = []
    z = processor(z, p)
    if set(tsearch).issubset(z): # https://www.geeksforgeeks.org/python/python-check-if-the-list-contains-elements-of-another-list/
        search.add(p)
    #if all(x in tsearch for x in z): # TODO in case we want to search paragraphs that only contain the desired tag(s)
        #search.add(p)

print(search)

    
    # if we edit something at the search, we need to write that change into the original file!
        # https://www.geeksforgeeks.org/python/how-to-search-and-replace-text-in-a-file-in-python/
        # we need an unique ID for each paragraph... a dict, as we'll need to know from each file
         # and each paragraph (not is preventing of us using an array with tuples or arrays inside :)
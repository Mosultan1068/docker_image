'''
this snip it is to show the usage of the escape characters in text
'''

print('I can\'nt believe it\'s true')

#alternativelly you can do the following , using the double quote;

print("I can't believe \" it's true") # adding the double quote to the text

print("I can't believe \n it's false") # adding a new line

print("I can't believe \t   .... it's false") #adding extra spaces

print("I can't believe \\   .... it's false") # to include a back slash

print('I can\'t believe \\  it\'s false') #to include the back slash as part of the text

print(f'I can\'t believe \t \n it\'s false'[11]) #format the text and retuen the 11th character

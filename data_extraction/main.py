"""
main.py

This class incorporates the funtionality of map.py and parser.py together and enables some shell handling to ensure
the correct args are being passed
"""
from sys import argv, exit
from parser import Parser
from map import Map


if __name__ == '__main__':
    if len(argv) < 3:
        print "Incorrect number of parameters. Type python main.py -h for more information"
        print argv
        exit(1)

    if '-h' in argv:
        print "Usage: python parser.py path/to/abstracts.tex path/to/prog.tex"
        exit(1)

    parser = Parser(argv[1], argv[2])

    # Extract all of the talks which have a flag associatd with them. Note: remove the Sundays sessions as they are not useful
    # for this project. In the future, if they are deemed necessary, simply remove the function, and modify parse_all() to not exlude
    # the first four entries such that parse...()[4::] => parse...()
    parser.prog_file = parser._remove_sunday_session(prog_file=True)
    invited_talks = parser.parse_invited_or_contributed_talks("Invited")
    contributed_talks = parser.parse_invited_or_contributed_talks("Contributed")
    poster_talks = parser.parse_invited_or_contributed_talks("Poster")
    
    # Need to manually append the abstracts with the title of "Welcome" as they are not given a flag within the
    # data/conference_data/SSC/2017/prog.tex file
    combined_talks = invited_talks + contributed_talks + poster_talks + [("Welcome", "Invited")] + [("Welcome", "Invited")]

    abstracts = parser.parse_all()
    mapper = Map(combined_talks)

    # Map the flags to their respective abstracts
    presenter_data = mapper.map(abstracts)
    
    # Write the file to disk
    parser.write_to_file(presenter_data, headers=['Abstract', 'Abstract Description', 'Name/Institution/Workplace', 'Time Slot', 'Flags'])

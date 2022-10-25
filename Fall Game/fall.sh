##These are the stick figures to be displayed if the user does a wrong guess

function wrong0 {
    echo "                      "
    echo "______________________"
    echo "                      "
    echo "   Rules :            "
    echo "                      "
    echo "  Player has to fill  "
    echo "  the alphabetic      "
    echo "  characters they     "
    echo "  think are right     "
    echo "  suited!             "
    echo "                      "
    echo "  Vowel characters    "
    echo "  already filled!     "
    echo "______________________"
    echo "                      "
}
function wrong1 {
    echo "         0            "
    echo "        /|\           "
    echo "        / \           "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "______________________"
    echo "                      "
}
function wrong2 {
    echo "                      "
    echo "                      "
    echo "        \0/           "
    echo "         |            "
    echo "        / \           "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "______________________"
    echo "                      "
}
function wrong3 {
    echo "                      "
    echo "                      "
    echo "                      "
    echo "         \0           "
    echo "       _ /\           "
    echo "         |            "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "______________________"
    echo "                      "
}
function wrong4 {
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "          \0/         "
    echo "        __/           "
    echo "         /            "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "______________________"
    echo "                      "
}
function wrong5 {
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "         \_\0         "
    echo "         /  \         "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "______________________"
    echo "                      "
}
function wrong6 {
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "        \             "
    echo "        /\/           "
    echo "         /0           "
    echo "______________________"
    echo "                      "
}
function wrong7 {
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "                      "
    echo "_______THE END________"
    echo "                      "
}

function display {
    DATA[0]=" #######    ###     #        #                      "
    DATA[1]=" #         #   #    #        #                      "
    DATA[2]=" #        #     #   #        #                      "
    DATA[3]=" #######  #######   #        #                      "
    DATA[4]=" #        #     #   #        #                      "
    DATA[5]=" #        #     #   #        #        ##  ##  ##  ##"
    DATA[6]=" #        #     #   #######  #######  ##  ##  ##  ##"
    echo


    # virtual coordinate system is X*Y ${#DATA} * 8
    ## This is to put the title in the centre

    REAL_OFFSET_X=$(($((`tput cols` - 56)) / 2))
    REAL_OFFSET_Y=$(($((`tput lines` - 6)) / 2))

    draw_char() {
        V_COORD_X=$1
        V_COORD_Y=$2

        tput cup $((REAL_OFFSET_Y + V_COORD_Y)) $((REAL_OFFSET_X + V_COORD_X))

        printf %c ${DATA[V_COORD_Y]:V_COORD_X:1}
    }

    trap 'exit 1' INT TERM

    tput civis
    clear
    tempp=8
    while :; do
        tempp=`expr $tempp - 8`
        for ((c=1; c <= 7; c++)); do
            tput setaf $c
            for ((x=0; x<${#DATA[0]}; x++)); do
                for ((y=0; y<=6; y++)); do
                    draw_char $x $y
                done
            done
        done
        sleep 1
        clear
        break
    done
}

##The main menu where you will be asked to choose the categories.
##And also if the user wants custom words, he/she can add the file path
function menu() {
    ## Supresses the error message that comes with the usage of GTK+
    exec 2> /dev/null
    ## Uses the zenity module, which comes pre-installed with Debian
    selection=$(zenity --list "Play the game" "Choose a topic" "Exit" --column="" --text="Choose an option" --title="Game options" --cancel-label="Quit")
    case "$selection" in
        "Play the game") main;;
        "Choose a topic") choice;;
        "Exit") exit;;
    esac
    echo
}
##This function allows the user to choose a topic or add one
function choice() {
    choose=$(zenity --list "Movies" "OS Topics" "English words" "Select a file" --column="" --text="Choose a list" --title="Game options" --cancel-label="Back")

    case $choose in
        "Movies") filename="movies";;
        "OS Topics") filename="OStopics";;
        "English words") filename="/usr/share/dict/american-english";;
        "Select a file") file_select;;
    esac
    menu
}

function file_select() {
    filename=$(zenity --file-selection --title="Select a file")
    case $? in
        0)
            echo "\"$filename\" selected";;
        1)
            echo "No file selected" ;;
        -1)
            echo "Unexpected error occurred" ;;
    esac
}

function main() {
    ##The function used to read the word list
    readarray a < $filename

    randind=`expr $RANDOM % ${#a[@]}`

    arr=${a[$randind]}

    guess=()

    guesslist=()
    guin=0

    arr=`echo $arr | tr -dc '[:alnum:] \n\r' | tr '[:upper:]' '[:lower:]'`
    len=${#arr}

    for ((i=0;i<$len;i++)); do
        guess[$i]="_"
    done

    mov=()

    for ((i=0;i<$len;i++)); do
         mov[$i]=${arr:$i:1}
         # echo -n "${mov[$i]} "
    done

    for ((j=0;j<$len;j++)); do
        if [[ ${mov[$j]} == " " ]]; then
            guess[$j]=" "
        fi
        if [[ ${mov[$j]} == "a" ]]; then
            guess[$j]="a"
        fi
        if [[ ${mov[$j]} == "e" ]]; then
            guess[$j]="e"
        fi
        if [[ ${mov[$j]} == "i" ]]; then
            guess[$j]="i"
        fi
        if [[ ${mov[$j]} == "o" ]]; then
            guess[$j]="o"
        fi
        if [[ ${mov[$j]} == "u" ]]; then
            guess[$j]="u"
        fi
    done

    ## Display the initial setup

    wrong=0

    while [[ $wrong -lt 7 ]]; do
        case $wrong in
            0)wrong0
            ;;
            1)wrong1
            ;;
            2)wrong2
            ;;
            3)wrong3
            ;;
            4)wrong4
            ;;
            5)wrong5
            ;;
            6)wrong6
            ;;
        esac

        notover=0
        for ((j=0;j<$len;j++)); do
            if [[ ${guess[$j]} == "_" ]]; then
                notover=1
            fi
        done

        echo Characters already used : ${guesslist[@]}
        echo Lifelines used out of 7 : $wrong
        for ((k=0;k<$len;k++)); do
            echo -n "${guess[$k]} "
        done
        echo
        echo

        if [[ notover -eq 1 ]]; then
            echo -n "Guess a letter: "
            read -n 1 -e letter
            letter=$(echo $letter | tr [A-Z] [a-z])
            guesslist[$guin]=$letter
            guin=`expr $guin + 1`
        fi

        f=0;
        for ((i=0;i<$len;i++)); do
            if [[ ${mov[$i]} == $letter ]]; then
                guess[$i]=$letter
                f=1
            fi
        done
        if [[ f -eq 0 ]]; then
            wrong=`expr $wrong + 1`
        fi

        if [[ notover -eq 0 ]]; then
            echo
            echo You Have Been Saved!
            echo $arr is the right answer
            echo
            play_again
        fi
        clear
    done

    wrong7
    echo You lost!
    echo The word was: $arr
    play_again
}

function play_again(){
    echo
    echo -n "Would you like to play again? (y/n) "
    read -n 1 choice
    case $choice in
        [yY]) clear
              main 
        ;;
    esac
    clear
    echo "                   "
    echo "-------------------"
    echo "                   "
    echo "Thanks for playing!"
    echo "                   "
    echo "----DEVELOPERS-----"
    echo "                   "
    echo "Keshav Lalit"
    echo "Jivesh Nanda"
    echo "Ritwij Aryan Parmar"
    echo "Lakshay Chugh"
    echo "                   "
    echo "-------------------"
    echo "                   "
    tput cnorm
    exit
}

function init(){
    clear
    ##This is the default file name if the user doesn't select any file
    filename="OStopics"
    
    echo
    display
    
    menu
}

init

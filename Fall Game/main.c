#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
 
int main(void) {
  pid_t pid = fork();
 
  if(pid == 0) {
    printf("Game Page => ParentPID: %d PID: %d\n", getppid(), getpid());
    printf("The Title page is about to be Loaded !!!!\n");
    system("gnome-terminal --window -- bash ./fall.sh");
    printf("Game Started.\n");
    printf("Press ENTER to go back to main page.\n");
    char x='k';
    while(x != '\n'){
        scanf("%c",&x);
    }
    exit(EXIT_SUCCESS);
  }
  else if(pid > 0) {
    printf("Main Page => PID: %d\n", getpid());
    wait(NULL);
    printf("Game Ended.\n");
  }
  else {
    printf("Unable to create child process.\n");
  }
 
  return EXIT_SUCCESS;
}

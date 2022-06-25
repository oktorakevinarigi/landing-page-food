#!/bin/bash
# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

COLOR_DEFAULT='\033[0m'
COLOR_RED='\033[31;5m'
COLOR_GREEN='\033[32m'
COLOR_YELLOW='\033[33m'
BLINK='\033[5m'

echo ""
echo ""
echo ""

CURRENT_BRANCH=$(git branch --show-current) # Get current branch name
if [ -z "`git status --porcelain`" ] # Check if there are any file changes, if (true)
    then
        # Proceed to next step
        echo "============================="
        echo "Deploy to:"
        echo "============================="
        echo "0: Dev"
        echo "1: Dev1"
        echo "2: Sanity"
        echo "3: RC (Release Candidate)"
        echo ""
        echo "Others or Empty to cancel!"
        echo "-----------------------------"
        echo ""
        printf "Select: "
        read ENV
        if [[ $ENV -eq 0 ]]
            then
                ENV_LABEL="Dev"
                TARGET_BRANCH="dev"
        else
            ENV_LABEL="Canceled"
            TARGET_BRANCH=""
        fi

        echo ""

        if [[ $TARGET_BRANCH != "" ]]
            then
                if [[ $TARGET_BRANCH == "master" ]]
                then
                    if [[ $CURRENT_BRANCH != "release/production" ]]
                    then
                        IS_PASS=0
                        EXPECTED_BRANCH="release/production"
                    fi
                else
                    IS_PASS=1
                fi

                if [[ $IS_PASS == 0 ]]
                then
                    echo -e "${COLOR_RED}Warning!${COLOR_DEFAULT}"
                    echo "==========================================================================="
                    printf ">> Release must use ${COLOR_YELLOW}${EXPECTED_BRANCH}${COLOR_DEFAULT} branch, your current branch is ${COLOR_YELLOW}$CURRENT_BRANCH${COLOR_DEFAULT}!"
                else
                    echo -e ">> Release on ${COLOR_YELLOW}$ENV_LABEL${COLOR_DEFAULT}"
                    echo "Processing..."
                    echo ""

                    IS_SUCCESS=0
                    if [[ $TARGET_BRANCH == "master" ]] || [[ $TARGET_BRANCH == "release/production" ]]
                    then
                        # Check local branch
                        if [ ! `git branch --list $TARGET_BRANCH` ]
                        then
                            # Create if not exist
                            git checkout -b $TARGET_BRANCH `origin/$TARGET_BRANCH`
                        else
                            # Change
                            git checkout $TARGET_BRANCH
                        fi

                        # Update it
                        git fetch origin $TARGET_BRANCH

                        # Merge the codes
                        git merge --ff-only $CURRENT_BRANCH

                        # Check conflicts
                        CONFLICTS=$(git ls-files -u | wc -l)
                        if [ "$CONFLICTS" -gt 0 ]
                        then
                            echo -e "${COLOR_RED}Warning!${COLOR_DEFAULT}"
                            echo "There is a merge conflict. Aborting..."
                            git merge --abort
                            IS_SUCCESS=0
                            # exit 1
                        else
                            # No conflict
                            if git push origin $TARGET_BRANCH
                            then
                                IS_SUCCESS=1
                            else
                                IS_SUCCESS=0
                            fi
                        fi
                    else
                        # Check local branch, if exist then delete it
                        # if [ `git branch --list $TARGET_BRANCH` ]
                        # then
                            git branch -D $TARGET_BRANCH
                        # fi

                        # Check remote branch, if exist then delete it
                        # if [ `git branch --list origin $TARGET_BRANCH` ]
                        # then
                            git push origin --delete $TARGET_BRANCH
                        # fi

                        # Create fresh branch from current branch
                        git checkout -b $TARGET_BRANCH
                        git push origin $TARGET_BRANCH

                        # Back to current branch
                        git checkout $CURRENT_BRANCH

                        IS_SUCCESS=1
                    fi

                    
                    if [[ $IS_SUCCESS == 1 ]]
                    then
                        echo ""
                        echo ""
                        echo -e "${COLOR_GREEN}Success!${COLOR_DEFAULT}"
                        echo "==========================================================================="
                        echo -e ">> Release on ${COLOR_YELLOW}$ENV_LABEL${COLOR_DEFAULT} with ${COLOR_YELLOW}$CURRENT_BRANCH${COLOR_DEFAULT} branch is Success"
                        printf ">> Your release will be available on server soon!"
                    else
                        echo -e "${COLOR_RED}Warning!${COLOR_DEFAULT}"
                        echo "==========================================================================="
                        printf ">> Release with ${COLOR_YELLOW}$CURRENT_BRANCH${COLOR_DEFAULT} branch is Failed!" 
                    fi
                fi
                
        else
            echo -e "${COLOR_RED}Warning!${COLOR_DEFAULT}"
            echo "==========================================================================="
            echo -e ">> Option not found in list"
            printf ">> Release is Canceled!"
        fi
else
    echo -e "${BLINK}${COLOR_RED}Warning!${COLOR_DEFAULT}"
    echo "==========================================================================="
    echo -e ">> Please push your latest update on ${COLOR_YELLOW}$CURRENT_BRANCH${COLOR_DEFAULT} branch to remote repository"
    printf ">> Release is Canceled!"
fi

read END
echo ""
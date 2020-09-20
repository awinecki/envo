Describe 'envo'

  Describe '[base logic]'

    It 'runs test script and uses env vars from .env'
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      result() { %text
        #|foofoo
        #|barbar
        #|external script has been run
      }
      When call ./envo -s ./spec/test_external.sh
      The output should eq "$(result)"
      The status should be success
      rm .env
    End

    It 'retains original env vars if set'
      export ENVO_FOO=old_foo ENVO_BAR=old_bar
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      result() { %text
        #|foofoo
        #|barbar
      }
      When call ./envo -s ./spec/test.sh
      The status should be success
      The output should eq "$(result)"
      The value "$ENVO_FOO" should equal "old_foo"
      The value "$ENVO_BAR" should equal "old_bar"
      rm .env
    End

    It 'leaves no superfluous env vars'
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      result() { %text
        #|foofoo
        #|barbar
      }
      When call ./envo -s ./spec/test.sh
      The status should be success
      The output should eq "$(result)"
      The value "$ENVO_FOO" should equal ""
      The value "$ENVO_BAR" should equal ""
      rm .env
    End

    It 'prints nothing when .env is empty'
      touch .env
      When call ./envo -s ./spec/test.sh
      The output should eq ""
      The status should be success
      rm .env
    End

  End


  Describe '[options]'

    It 'allows specifying custom env file via -f path/to/file opt'
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .my_custom_env_file
      result() { %text
        #|foofoo
        #|barbar
      }
      When call ./envo -s -f .my_custom_env_file ./spec/test.sh
      The output should eq "$(result)"
      The status should be success
      rm .my_custom_env_file
    End

    It 'allows to override an env var with -e KEY=VALUE opt'
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      result() { %text
        #|overriden_foofoo
        #|barbar
      }
      When call ./envo -s -e ENVO_FOO=overriden_foofoo ./spec/test.sh
      The output should eq "$(result)"
      The status should be success
      rm .env
    End

    It 'allows to override an env var with -e KEY=VALUE opt (multiple env vars)'
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      result() { %text
        #|overriden_foofoo
        #|overriden_barbar
      }
      When call ./envo -s -e ENVO_BAR=overriden_barbar -e ENVO_FOO=overriden_foofoo ./spec/test.sh
      The output should eq "$(result)"
      The status should be success
      rm .env
    End

  End


  Describe '[help]'
    It 'displays help / usage'
      usage_first_line() { %text
        #|usage: envo [-v] [-h] [-nc] [-s] [-e KEY=VALUE] [-f infile] command
      }
      When call ./envo --help
      The line 1 of output should eq "$(usage_first_line)"
      The status should be success
    End
  End

  Describe '[error handling]'
    It 'displays error when running without command'
      usage_first_line() { %text
        #|usage: envo [-v] [-h] [-nc] [-s] [-e KEY=VALUE] [-f infile] command
      }
      touch .env
      When call ./envo -s
      The line 1 of output should eq "$(usage_first_line)"
      The status should be failure
      rm .env
    End

    It 'displays error when running nonexistent command'
      usage_first_line() { %text
        #|[envo] ERROR: command not found
      }
      # touch .env
      env_file() { %text
        #|ENVO_FOO=foofoo
        #|ENVO_BAR=barbar
      }
      env_file > .env
      When call ./envo -s -nc some_nonexistent_command with some params
      The line 1 of output should eq "$(usage_first_line)"
      The status should be failure
      rm .env
    End

    It 'prints usage when run with no arguments'
      usage_first_line() { %text
        #|usage: envo [-v] [-h] [-nc] [-s] [-e KEY=VALUE] [-f infile] command
      }
      When call ./envo
      The line 1 of output should eq "$(usage_first_line)"
      The status should be failure
    End
  End

End

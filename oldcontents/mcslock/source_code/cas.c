compare_and_swap (*p, oldval, newval):
              if (*p == oldval)
          *p = newval;
          success;
              else
                  fail;

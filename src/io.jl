"""
# Function call

`printuln(r...;label="")`

# Description

This function prints a real or complex variable in an optionally specified unit

# Variables

`r[1]` Text string to printed, indicating the variable name or description; a
maximum of 16 characters is allowes, in case the optional variable `label` is
NOT specified; in  case of specifying the variable `label`, the maximum length
of `r[1]` may not exceed 12 characters

`r[2]` Variable to be printed; the variable may be real or complex, units
assigned from the module Unitful are allowed; vectors of variables are also
allowed

`r[3]` Optional target unit of `r[2]` to be displayed

`label` Optional four character label structuring the output of variables, e.g.,
`label = "(a)"`

# Examples

```julia
julia> using Unitful,Unitful.DefaultSymbols,EE
julia> U1=300V+j*400V
julia> printuln("U1",U1,kV)
              U1 = 0.3 kV + j 0.4 kV
                 = 0.5 kV ∠ 53.1301°
julia> printuln("U1",U1,label="(a)")
(a)           U1 = 300 V + j 400 V
                 = 500 V ∠ 53.1301°
```
"""
function printuln(r...;label="")
    # r[1] = 1st argument = string to be printed
    # r[2] = 2nd argument = quantity to shown
    # r[3] = 3rd argument = optional output unit
    # If unit is specified as preferred 3rd argument, then convert number
    # to thís argument
    for k in collect(1:size(r[2],1))
        if length(r)>=3
            # Convert numerical value to specified units
            # Change printed unit
            num = uconvert(r[3],r[2][k])
        else
            num = r[2][k]
        end
        numunit = unit(num)

        # Real and imaginary part
        numre = ustrip(real(num))
        numim = ustrip(imag(num))
        # Magnitude and angle
        numabs = abs(ustrip(num))
        numargdeg = angle(ustrip(num))*180/pi
        # Determine unit associated to numeric value and consider
        # special spelling of units

        # Print text string (1st argument)
        if size(r[2],1)==1
          # Second argument (string) is a scalar value
          if label==""
              @printf("%16s = ",r[1])
          else
              @printf("%-4s%12s = ",label,r[1])
          end
        else
          # Second argument (string) is a vector
          if label==""
              @printf("%16s = ",r[1]*"["*@sprintf("%i",k)*"]")
          else
              if k==1
                  # Print label only in first entry
                  @printf("%-4s%12s = ",label,r[1]*"["*@sprintf("%i",k)*"]")
              else
                  # Omit label on sencond and following entries
                  @printf("%16s = ",r[1]*"["*@sprintf("%i",k)*"]")
              end
          end
        end
        @printf("%g %s",numre,numunit)
        if numim>0
            @printf(" + j %g %s\n",abs(numim),numunit)
            @printf("%16s = %g %s ∠ %g°\n","",numabs,numunit,numargdeg)
        elseif ustrip(imag(num))<0
            @printf(" - j %g %s\n",abs(numim),numunit)
            @printf("%16s = %g %s ∠ %g°\n","",numabs,numunit,numargdeg)
        else
            @printf("\n")
        end
    end
end

# METHODS

# prompt display
def prompt(input)
  puts "=> #{input}"
end

# validates if loan amount is more than $0 and if it's a float.
def valid_loan_amount?(loan_amount_input)
  if Float(loan_amount_input, exception: false) &&
     loan_amount_input.to_f > 0 && !loan_amount_input.empty?
    true
  else
    false
  end
end

# validates if APR is at least 0% and if it's a float.
def valid_apr?(apr_input)
  if Float(apr_input, exception: false) &&
     apr_input.to_f >= 0 && !apr_input.empty?
    true
  else
    false
  end
end

# validates if the loadn duration is greater than 0 months
# and if it's an integer.
def valid_duration?(loan_duration_input)
  if Integer(loan_duration_input, exception: false) &&
     loan_duration_input.to_i > 0 && !loan_duration_input.empty?
    true
  else
    false
  end
end

# rounds to the nearest two decimal places
def decimal_rounder(input)
  format('%.2f', input)
end

# dramatic effects
def calculation_pause
  print 'Calculating'
  3.times do
    print '.'
    sleep(0.5)
  end
  puts "\n"
end

# main body of code
prompt <<-MSG
Welcome to car loan calculator!
By providing your loan amount, APR, and loan duration,
you will be able to calculate your:
1) Monthly interest rate
2) Loan duration
3) Monthly payments.

MSG

loop do
  loan_amount = ''
  prompt 'First, enter your loan amount.'
  loop do
    loan_amount_input = gets.chomp.tr('$', '')
    if valid_loan_amount?(loan_amount_input)
      loan_amount = loan_amount_input.to_f
      break
    else
      prompt 'This is an invalid loan amount. Enter a value greater than $0.'
    end
  end

  apr = ''
  prompt 'Next, enter your APR in percentages (e.g. 15 for 15%).'
  loop do
    apr_input = gets.chomp.tr('%', '')
    if valid_apr?(apr_input)
      apr = (apr_input.to_f) / 100
      break
    else
      prompt 'This is an invalid APR. Enter a value that is 0% or greater.'
    end
  end

  loan_duration_months = ''
  prompt 'Finally, enter your loan duration in months'
  loop do
    loan_duration_input = gets.chomp.tr('months', '')
    if valid_duration?(loan_duration_input)
      loan_duration_months = loan_duration_input.to_i
      break
    else
      prompt 'This is not a valid input. Make sure you enter digital numbers.'
      prompt '(e.g. 4 instead of four)'
    end
  end

  # calculations
  monthly_interest_rate = apr / 12
  monthly_interest_rate_percentage = decimal_rounder((apr / 12) * 100)
  monthly_payment = loan_amount * (monthly_interest_rate /
                    (1 - (1 + monthly_interest_rate)**(-loan_duration_months)))
  monthly_payment_rounded = decimal_rounder(monthly_payment)
  calculation_pause
  prompt <<-MSG
Below are the results of your car loan calculation:
  1) Monthly interest rate: #{monthly_interest_rate_percentage}%
  2) Loan duration: #{loan_duration_months} months
  3) Monthly payment: $#{monthly_payment_rounded}

  MSG

  prompt 'Would you like to do another calculation? (enter \'y\' for yes)'
  answer = gets.chomp
  break unless answer.downcase.start_with?('y')
end

prompt 'Thank you for using the car loan calculator. Have a good day!'

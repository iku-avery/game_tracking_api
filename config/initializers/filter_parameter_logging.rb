# rubocop:disable Layout/LineLength
# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# rubocop:enable Layout/LineLength
Rails.application.config.filter_parameters += %i[
  passw email secret token _key crypt salt certificate otp ssn cvv cvc
]

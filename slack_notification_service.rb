class SlackNotificationSevice

	def initialize
	  bt_slack_config = Psych.load_file("braintree_slack_config.yaml")
	  bt_slack_config["config"].each { |key, value| instance_variable_set("@#{key}", value) }

	  @bt_env = "www" unless @bt_env == "sandbox"

	  @slackbot = SlackNotify::Client.new(
			webhook_url: @slack_url,
			channel: @slack_channel,
			username: @slack_username,
			icon_emoji: @slack_emoji,
			link_names: 1
		)
	end

	def transaction_notification(braintree_transaction)
		transaction_details = _extract_relevant_details(braintree_transaction)
		if transaction_details[:status] == "processor_declined"
			@slackbot.notify("
				Transaction Declined in Braintree!\n
				#{transaction_details[:customer_email]}'s payment for #{transaction_details[:amount]} was declined with this message:\n
				#{transaction_details[:message]}.\n 
				<https://#{@bt_env}.braintreegateway.com/merchants/#{@bt_merchant_id}/transactions/#{transaction_details[:id]}|See transaction #{transaction_details[:id]} in Braintree.>
			")
		else 
			@slackbot.notify("
				Transaction Successful in Braintree!\n
				#{transaction_details[:customer_email]}'s payment for #{transaction_details[:amount]} was successful!\n 
				<https://#{@bt_env}.braintreegateway.com/merchants/#{@bt_merchant_id}/transactions/#{transaction_details[:id]}|See transaction #{transaction_details[:id]} in Braintree.>
			")
		end
	end

	def _extract_relevant_details(braintree_transaction)
		details = {}
		details[:id] = braintree_transaction.transaction.id
		details[:amount] = braintree_transaction.transaction.amount.to_int.to_s
		details[:status] = braintree_transaction.transaction.status
		details[:customer_email] = braintree_transaction.transaction.customer_details.email
		details[:message] = braintree_transaction.message if !braintree_transaction.success?
		
		details
	end
end

lala = SlackNotificationSevice.new
# Customer Reward Management System

## Use case
When a user on our website chooses a specific reward deal and agrees to the terms and conditions, we initiate a workflow. This workflow retrieves the user's details from our Loyalty Engine. These details are then forwarded to the Reward Vendor. Upon successful receipt of the information, the Reward Vendor responds with a 200 status. Subsequently, they POST a 16-digit number to us (i.e. the Reward Confirmation Receiver). This reward confirmation number is stored in the user's profile, allowing them to available discount.

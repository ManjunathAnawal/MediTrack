# MediTrack

## Medication Consumption tracking app

App keeps track of medication consumption by the user.
* Every day user takes medicines three times - Morning, Afternoon and Night. The app
does not track which medicine but if the patient has taken the medicine.

* Whenever the user takes medicine, the user must go to the app and click on a button,
so that the app knows the user has taken medicine.

Features: -

1. App has two screen prototypes shown below.

Below is the first screen with greeting message based on time, Total score for the day and
button to indicate the user has taken the medicine.

<img width="344" alt="Screenshot 2022-07-31 at 7 34 58 PM" src="https://user-images.githubusercontent.com/68315391/182030154-0cadb2ce-e533-45ca-918f-c62dacd9cce7.png">

The history screen shows a history of medications taken by the user. The app persist history so that the user can come back any time and check his history.

<img width="347" alt="Screenshot 2022-07-31 at 7 35 17 PM" src="https://user-images.githubusercontent.com/68315391/182030292-7c24d01d-febd-4828-a917-24cd10c524c2.png">


2. Scores distribution:
Morning medicine: 30, Afternoon medicine: 30, Night medicine: 40

3. Every day, the app notify the user if user has not taken medicine by 11 am for
morning, 2pm for afternoon and 8pm for night. If user had already taken the medicine,
then it ignores notification. It displays a local notification with proper message
as to reminder user which time of day’s medication to be taken is pending.

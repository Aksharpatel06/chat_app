# Chatify [(Source Code)](https://github.com/Aksharpatel06/chat_app/tree/master/lib)

You're building a **Flutter chat app** using **GetX** state management and **Firebase** services for authentication and real-time data handling. Here's a breakdown of the app's features and how they interact:

### 1. **User Authentication**
   - **Google Sign-In & Mobile Authentication**: The app allows users to sign in with their Google account or via mobile phone number (OTP-based verification). This ensures a secure and easy login process, managed through Firebase Authentication.

### 2. **Real-Time Messaging**
   - **Send and Receive Messages**: Users can send and receive text-based messages in real time. The messages are stored and retrieved from **Firebase Firestore**.
   - **Message Status (Double Tick)**: When a message is sent, a single tick appears. When the recipient receives the message, a double tick is shown, giving users feedback on message delivery.
   - **Date and Time**: Each message is timestamped, allowing users to see when a message was sent or received.

### 3. **Theme Support**
   - **Dark and Light Theme**: The app offers both dark and light themes, enabling users to switch between modes based on their preference. GetX makes it easy to handle state changes for theming.

### 4. **Firebase Cloud Database (Firestore)**
   - **Firestore Integration**: Messages and user data are stored in Firebase Firestore, providing real-time updates and scalable data storage.
   - **Real-Time Sync**: As soon as a message is sent, it’s instantly synced across all devices of the involved users, ensuring a seamless chat experience.

### 5. **Date and Time Display**
   - The app displays **date and time** next to each message, so users can easily track the context of conversations. The format is adjustable according to user preferences or locale settings.

### 6. **GetX State Management**
   - **Reactive UI Updates**: The app utilizes **GetX** for efficient state management. This ensures instant UI updates whenever a message is sent or received, or when other states (like theme change or authentication) need to be reflected.
   - **Efficient Navigation**: With GetX’s route management, transitions between screens (such as login, chat screens, and profile screens) are smooth and fast.

### Overall User Experience
   - The app focuses on **speed** and **simplicity**, with **smooth animations** and **real-time messaging**. GetX helps maintain a **lightweight** and **performant** architecture, ensuring the app runs efficiently even with complex features like real-time message updates, multiple authentication methods, and dynamic theme switching.

## ScreenShorts

### **Light Mode : -** 
<p align='center'>
  <img src='https://github.com/user-attachments/assets/64f31000-b67b-4e4f-b910-010a061e3531' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/2c364089-7d71-463d-bad4-efc6b1a654af' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/68fcd014-af05-4c27-b1e8-d70975b27c7d' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/a8a17b72-a689-46e1-8113-9570ce664758' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/a35160d7-cf4c-4cea-88a1-b65592b45fee' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/e6d5145d-f507-44ac-9424-0b34a9fb6637' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/94c88d0a-32b9-45d8-9623-4b94b93d0639' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/366d596b-fedf-4c41-8404-8539788ca5f5' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/aa545a84-91ea-4689-93b2-87dd7a11993c' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/f6a259ad-37ac-40f1-bc11-0c0bc9cae17b' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  
</p>

### **Dark Mode : -**
<p align ='center'>
  <img src='https://github.com/user-attachments/assets/5c475c70-28e4-43f8-9b24-56ebad3ad63c' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/a683eddf-ed84-45af-8e4e-8a5fc07e3fa9' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/2ba5d6bc-e08f-47bf-9446-da29f9c8592c' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/8c3b9eba-4f04-45c2-b0ac-eb86a9a22463' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/69a1db77-edc3-4dd0-8720-616e3939bf22' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/1cdd5fef-042e-4e36-ae50-89ba0ac4f98c' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/79752bf4-b837-41c8-bc0c-2e73a7952aba' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
  <img src='https://github.com/user-attachments/assets/59672e18-1475-4478-9823-a0a25d199cf1' width=240> &nbsp;&nbsp;&nbsp;&nbsp;
</p>

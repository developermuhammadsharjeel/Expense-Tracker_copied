# Loan Tracking Feature

## Overview
This feature adds comprehensive loan tracking functionality to the Expense Tracker app, allowing users to track money they have lent to others or borrowed from others.

## Features

### 1. Dual Loan Types
- **Loans Given**: Track money lent to others
- **Loans Received**: Track money borrowed from others

### 2. Draft Mode
- Users can create loan entries in "draft mode"
- Draft loans are saved but **do not affect the balance**
- Draft loans can be converted to saved loans later
- This allows users to record loan information without immediately impacting their balance

### 3. Balance Management
- **Saved Loans** affect the balance:
  - Loans Given (lent): **Deduct** from balance
  - Loans Received (borrowed): **Add** to balance
- Draft loans have **no impact** on balance
- Balance calculation is shown on the main screen with loan impact indicator

### 4. User Interface

#### Main Screen
- New "Loan Tracking" section card
- Tapping opens the loan management screen
- Shows balance with loan impact included

#### Loan List Screen
- Summary cards showing:
  - Total Loans Given (total and saved amounts)
  - Total Loans Received (total and saved amounts)
  - Net Balance Impact
- Complete loan history with details
- Draft loans clearly marked with orange badge
- "Save Now" button for draft loans

#### Add Loan Screen
- Radio buttons to select loan type (Given/Received)
- Fields for:
  - Person's name
  - Amount
  - Date
  - Description (optional)
- Draft mode checkbox with explanation
- Save button to create the loan

### 5. Loan Details
Each loan entry includes:
- Unique loan ID
- Loan type (Given/Received)
- Person's name (to/from whom money is lent/borrowed)
- Amount
- Date
- Draft status
- Optional description

## Technical Implementation

### Data Layer
- **Loan Model** (`packages/expense_repository/lib/src/models/loan.dart`)
  - Contains all loan properties
  - Includes `LoanType` enum for type safety
  
- **LoanEntity** (`packages/expense_repository/lib/src/entities/loan_entity.dart`)
  - Firebase document serialization/deserialization
  
- **Repository Methods** (added to `ExpenseRepository`)
  - `createLoan(Loan loan)`: Create a new loan
  - `getLoans()`: Fetch all loans
  - `updateLoan(Loan loan)`: Update existing loan (e.g., draft to saved)

### BLoC Layer
- **CreateLoanBloc**: Handles loan creation and updates
- **GetLoansBloc**: Manages loan fetching and state

### UI Layer
- **AddLoan Screen**: Form for creating new loans
- **LoanListScreen**: Display and manage loans
- **MainScreen**: Updated to show loan section and calculate adjusted balance

### Firebase Integration
- New `loans` collection in Firestore
- Each loan stored as a document with its ID

## Usage Flow

### Adding a Draft Loan
1. Open Loan Tracking from main screen
2. Tap the + button
3. Select loan type (Given/Received)
4. Fill in person's name and amount
5. Keep "Save as Draft" checked
6. Tap Save
7. Loan is saved but balance remains unchanged

### Converting Draft to Saved
1. Open Loan Tracking
2. Find the draft loan (marked with orange DRAFT badge)
3. Tap "Save Now" button
4. Confirm in dialog
5. Loan is marked as saved and balance is updated

### Adding a Saved Loan Directly
1. Open Loan Tracking from main screen
2. Tap the + button
3. Select loan type
4. Fill in details
5. **Uncheck** "Save as Draft"
6. Tap Save
7. Loan is saved and balance is immediately updated

## Balance Calculation
```
Adjusted Balance = Total Expenses + Loan Impact

Where:
Loan Impact = Sum of (Saved Loans Received) - Sum of (Saved Loans Given)
```

## Design Preservation
- Maintains existing app design and color scheme
- Follows existing patterns for navigation and UI components
- Does not modify existing expense tracking functionality
- Seamlessly integrates with the existing home screen layout

## Future Enhancements (Not Implemented)
- Loan repayment tracking
- Partial payment support
- Loan reminders
- Interest calculation
- Export loan history

# Message Handling in RAP

## Overview

Message handling is a crucial aspect of RESTFUL ABAP Programming (RAP). It offers an important way to guide and validate consumer and user actions, and helps to avoid and resolve problems. Thus, messages are important to communicate problems to a consumer or user. Well-designed messages help to recognize, diagnose, and resolve issues. That's why it's important to always use messages consistently and optimize the interaction as a whole. Consequently, errors and warnings that require action should be clearly stated and described in a way that helps to resolve the issue quickly and efficiently. It’s recommended to provide a message for each entry in the fail structure to give additional information.

> [!TIP]
> Messages in RAP can be associated with entity level, field level, or action/function level contexts. For a detailed guidance on message severity levels (Success, Information, Warning, Error), best practices, and implementation patterns, refer to [Messages](https://help.sap.com/docs/abap-cloud/abap-rap/messages) on SAP Help Portal.

## Message Types

### State Messages

State messages refer to a business object instance and its values. They reflect the current state of the business object and are persisted until the state that caused the message is changed.

Key characteristics of state messages:

- Always bound to a business object entity (cannot use **%OTHER** component)
- Must include **%state_area** component to identify the condition
- Persisted until the causing state changes
- Used in validations, determinations, and save operations
- Must be invalidated to prevent message accumulation

> [!NOTE]
> For more information, refer to [State Messages](https://help.sap.com/docs/abap-cloud/abap-rap/state-messages) on SAP Help Portal.

### Transition Messages

Transition messages refer to a triggered request and are only valid during the runtime of the request. Unlike state messages, they relate to the transition between states rather than the current state of the business object.

Key characteristics of transition messages:

- Valid only during request runtime
- Related to state transitions, not current state
- Can be bound (**with %tky**) or unbound (**without %tky**)

> [!NOTE]
> For more information, refer to [Transition Messages](https://help.sap.com/docs/abap-cloud/abap-rap/transition-messages) on SAP Help Portal.

## Implementation Approaches

### 1. Using Message Classes and Message Exception Classes (Recommended)

#### Message Classes

Message classes provide a way to define and manage messages in a centralized manner. They allow you to group related messages and provide a consistent way to access them.

#### Message Exception Classes

A Message exception class in ABAP RAP is a specialized ABAP class that extends standard exception handling to provide structured, reusable message management for RAP applications. It serves as a bridge between traditional ABAP message classes and the modern RAP messaging framework. It is used to encapsulate the messages stored in a message class to handle the formatting of message variable types like dates or amounts through the exception class.

We have implemented a message exception class for our application. You can refer to the implementation at [`Message Exception Class`](../src/zpra_mf_service/zcm_pra_mf_messages.clas.abap).

A sample usage of the message exception class can be found in the Music Festival's [`behavior implementation class`](../src/zpra_mf_service/zbp_pra_mf_r_musicfestival.clas.locals_imp.abap).

This is a code snippet from the behavior implementation class, validating the event date and time to be in the future, with messages created using the message exception class:

```abap
METHOD validateDate.

  READ ENTITIES OF ZPRA_MF_R_MusicFestival IN LOCAL MODE
    ENTITY MusicFestival
      FIELDS ( EventDateTime )
      WITH CORRESPONDING #( keys )
      RESULT DATA(events).

  LOOP AT events REFERENCE INTO DATA(event).

    INSERT VALUE #( %tky = event->%tky %state_area = zcm_pra_mf_messages=>state_area-validate_date )
            INTO TABLE reported-musicfestival.

    IF event->EventDateTime IS NOT INITIAL AND event->EventDateTime < utclong_current( ).

      INSERT VALUE #( %tky = event->%tky ) INTO TABLE failed-musicfestival.
      INSERT VALUE #( %tky                   = event->%tky
                      %state_area            = zcm_pra_mf_messages=>state_area-validate_date
                      "Event date and time must be in the future.
                      %msg                   = NEW zcm_pra_mf_messages(
                                                        textid   = zcm_pra_mf_messages=>event_datetime_invalid
                                                        severity = if_abap_behv_message=>severity-error )
                      %element-EventDateTime = if_abap_behv=>mk-on ) INTO TABLE reported-musicfestival.
    ENDIF.
  ENDLOOP.

ENDMETHOD.
```

> [!NOTE]
> For detailed information on creating and using message exception classes, refer to [Creating a Message Exception Class](https://help.sap.com/docs/abap-cloud/abap-rap/creating-message-exception-class) on SAP Help Portal.

### 2. Direct Message Creation

For simple scenarios or prototyping, you can create messages directly:

```abap
APPEND VALUE #( %tky = <entity>-%tky
                %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-warning
                  text = |Message Text| ) ) TO reported-entity.
```

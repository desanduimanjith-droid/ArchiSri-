ArchiSri: AI & IoT-Powered Home Design Platform

ArchiSri is a hybrid technological platform designed to automate and safeguard the architectural planning process. Developed as a Software Development Group Project at the Informatics Institute of Technology (IIT) in collaboration with the University of Westminster, the system integrates Generative AI and Internet of Things (IoT) telemetry to provide environment-adaptive house designs tailored to Sri Lanka's unique terrain.


🚀 Key Features

  * AI Blueprint Generation (UC-001): Automatically produces optimized 2D and 3D house layouts based on user inputs such as room count, budget, and land dimensions.

  * IoT Smart Site Analyzer: Interfaces with a physical "Smart Site Analyzer" to retrieve real-time environmental data, including:

  * Pore Pressure (Piezometers): To predict landslide risks in hilly regions.

  * Inclinometer (Tilt Sensors): To monitor slope stability.

  * Salinity/EC Sensors: To identify corrosive risks in coastal areas.

  * Autonomous Design Adaptation: The AI automatically modifies blueprints—for example, by adding retaining walls or selecting specific foundation types (e.g., Raft or Pile)—if high-risk conditions are detected by sensors.

  * Pro-Connect & Material Marketplace:

  * Contractor Matching: Connects homeowners with verified, nearby construction professionals based on GPS location.

  * Smart Recommendations: Suggests specialized materials, such as Sulfate Resisting Cement or Epoxy-coated rebars, based on the site's environmental report.



🏗️ Technical Architecture

  * The system utilizes a 3-tier Layered Architecture to ensure modularity and scalability:

  * Presentation Layer: Built using Flutter for the mobile application and a web portal for administrative oversight.

  * Services Layer: Manages core business logic, including the 3D AI Blueprint Generator Service, IoT Analysis Service, and User Management.

  * Database Layer: Stores critical data including user profiles, sensor telemetry logs, and generated design history.



🛠️ Tech Stack

  * Mobile Frontend: Flutter (Dart).

  * Backend: Node.js.

  * Database: Firebase.

  * AI/ML: TensorFlow or PyTorch for generative design.

  * Hardware: ESP32-based microcontrollers.


🛡️ Safety, Legal, & Ethics

  * Human-in-the-loop: ArchiSri is a "preliminary tool"; an accredited engineer must review and approve any digital blueprint before construction begins.

  * Standards Compliance: Safety thresholds for material and structural recommendations are programmed according to Sri Lanka Standards (SLS) and NBRO guidelines.

  * Security: Sensitive user data and GPS coordinates are protected using AES-256 encryption and TLS 1.3 HTTPS transport.


Group ID: SE 25

Authors

  * P.V.G. Desandu Imanjith
  * W.M. Garuka Madubashana
  * S.A. Sithija Meghana Senanayaka
  * P.V. Ojith Adithya
  * Siluna Sunsilu Pathirana
  * Kavira Bathisa Attanayake

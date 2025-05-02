# Restaurant Management API

A comprehensive RESTful API built with Ruby on Rails for restaurant operations management, including order processing, table management, menu items, invoicing, and staff coordination.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Authentication and Authorization](#authentication-and-authorization)
- [Real-time Features](#real-time-features)
- [Setup and Installation](#setup-and-installation)
- [Docker Support](#docker-support)
- [Deployment](#deployment)
- [Testing](#testing)

## Overview

The Restaurant Management API is a backend service designed to support the operations of a restaurant, from taking orders and processing them in the kitchen to managing tables and generating invoices. The system provides a real-time communication layer for instant updates between waiters, kitchen staff, and management.

## Features

- **User Management**: Role-based access for staff (waiters, cooks, administrators)
- **Table Management**: Track table status (available, occupied) and capacity
- **Menu Management**: Product catalog with categories, descriptions, and prices
- **Order Processing**: Complete order lifecycle from creation to fulfillment
  - Create orders with multiple items
  - Process orders in the kitchen
  - Dispatch individual items as they are prepared
  - Mark orders as completed
- **Invoicing**: Generate and manage invoices for completed orders
- **Client Management**: Store customer information for loyalty programs and invoicing
- **Real-time Updates**: WebSocket integration for instant communication between staff
- **Audit Logging**: Track system events and changes for operational analysis

## Tech Stack

- **Ruby**: 3.2.2
- **Rails**: 7.1.2
- **Database**: PostgreSQL
- **Authentication**: Devise with JWT tokens
- **Authorization**: CanCanCan for role-based access control
- **WebSockets**: Action Cable with Faye for real-time communication
- **API Serialization**: Panko Serializer for fast JSON rendering
- **Background Processing**: Redis for caching and job queues
- **Testing**: RSpec for test suite
- **Containerization**: Docker support for easy deployment

## Database Schema

The system is built around these primary entities:

- **Users**: Staff members with roles (waiter, cook, admin)
- **Tables**: Restaurant tables with status and capacity information
- **Products**: Menu items with prices and categories
- **Orders**: Customer orders linked to tables and waiters
- **Items**: Individual items within an order with preparation status
- **Clients**: Customer records for loyalty and invoicing
- **Invoices**: Financial records of completed orders
- **Events**: Audit trail of system activities

## API Endpoints

### Authentication
- Authentication via Devise/JWT

### Tables
- `GET /tables` - List all tables
- `GET /tables/:id` - Show table details
- `PUT /tables/:id` - Update table information
- `POST /tables/:id/occupy` - Mark table as occupied
- `POST /tables/:id/release` - Mark table as available

### Products
- `GET /products` - List all menu items
- `GET /products/:id` - Show product details
- `POST /products` - Create new product
- `PUT /products/:id` - Update product
- `DELETE /products/:id` - Remove product

### Orders
- `GET /orders` - List orders
- `GET /orders/:id` - Show order details
- `POST /orders` - Create new order
- `PUT /orders/:id` - Update order
- `PUT /orders/:id/in_process` - Mark order as in preparation
- `PUT /orders/:id/dispatch_order` - Mark order as complete
- `PATCH /orders/:id/dispatch_item/:item_id` - Mark specific item as prepared

### Items
- `GET /items` - List order items
- `POST /items` - Add item to order
- `PUT /items/:id` - Update order item
- `DELETE /items/:id` - Remove item from order

### Clients
- `GET /clients` - List clients
- `POST /clients` - Create client
- `GET /clients/:id` - Show client details
- `PUT /clients/:id` - Update client
- `DELETE /clients/:id` - Remove client

### Invoices
- `GET /invoices` - List invoices
- `GET /invoices/:id` - Show invoice details
- `POST /invoices` - Generate new invoice

### Audits
- `GET /audits` - Access system event logs

## Authentication and Authorization

The API uses JWT (JSON Web Token) authentication via Devise and Devise-JWT. Authorization is implemented using CanCanCan with the following roles:

- **Admin**: Full access to all features
- **Waiter**: Manage tables, create/update orders, add clients
- **Cook**: Update order and item status

## Real-time Features

The application uses Action Cable and Faye WebSockets to provide real-time updates:

- Order status changes are instantly communicated to staff
- New orders appear immediately in the kitchen interface
- Table status updates are broadcast in real time

## Setup and Installation

### Prerequisites
- Ruby 3.2.2
- PostgreSQL
- Redis

### Local Setup
```bash
# Clone the repository
git clone https://github.com/scaminom/restaurant-api.git
cd restaurant-api

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed  # Optional: add sample data

# Start the server
rails server
```

## Docker Support

The application includes Docker configuration for easy deployment:

```bash
# Build the Docker image
docker build -t restaurant-api .

# Run the container
docker run -p 3000:3000 restaurant-api
```

## Deployment

The repository includes configuration for deployment on Render:

```yaml
# render.yaml
services:
  - type: web
    name: restaurant-api
    env: ruby
    buildCommand: bundle install && bundle exec rake assets:precompile
    startCommand: bundle exec puma -C config/puma.rb
    envVars:
      - key: RAILS_MASTER_KEY
        sync: false
```

## Testing

The application uses RSpec for testing:

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/order_spec.rb
```

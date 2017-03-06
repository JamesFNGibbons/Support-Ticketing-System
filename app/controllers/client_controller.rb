class ClientController < ApplicationController
    def index
        #check if the user is loggedin as a staff member
        if(session[:staff_loggedin])
           if(!params[:view_home])
              redirect_to '/staff'
           end
        end
    end
    
    def view_ticket
        #check if the user is loggedin
        if(session[:client_loggedin])
            if(session[:ticket_id])
                @ticket_id = session[:ticket_id]
            end
            
            #get the ticket data from the database
            @ticket =OpenTicket.where(ticket_id: @ticket_id)[0]
            
            #Check if a staff member has responded to the ticket
            if(StaffResponse.where(ticket_id: @ticket_id).count == 0)
                @staff_has_responded = false;
            else
                @staff_has_responded = true;
            end
        end
    end
    
    def close_ticket
        #check if the user is loggedin
        if(session[:client_loggedin])
            if(session[:ticket_id])
                @ticket_id = session[:ticket_id] 
            end
            
            #Get the current support ticket data and move to the closed_tickets
            ticket = OpenTicket.where(ticket_id: @ticket_id)[0]
            
            name = ticket.name;
            email = ticket.email;
            product = ticket.product;
            issue = ticket.issue;
            
            ClosedTicket.create(
                name: name,
                email: email,
                product: product,
                ticket_id: @ticket_id,
                issue: issue,
                closure_reason: 'Closed By Client'
            )
            
            #delete the ticket from the database
            OpenTicket.delete(ticket.id);
                
            render 'ticket_closed'
        else
            redirect_to '/login'
        end
    end
    
    def login
        #check if the user is trying to login.
        if(params[:ticket_id])
            ticket_id = params[:ticket_id]
            
            #check if the login is correct
            if(OpenTicket.where(ticket_id: ticket_id).count == 1)
               session[:client_loggedin] = true
               session[:ticket_id] = ticket_id
               
               redirect_to '/view-ticket'
            else
                #Check if the ticket was closed
                if(ClosedTicket.where(ticket_id: ticket_id).count == 1)
                    @ticket_is_closed = true;
                else
                    @ticket_is_closed = false;
                end
                #invalid support ticket
                @invalid_ticket = true;
            end
        end
    end
    
    def open_ticket
        name = params[:name]
        email = params[:email]
        product = params[:product]
        issue = params[:issue]
        
        if(name && email && product && issue)
           #generate a randome string for the ticket id
           o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
           ticket_id = (0...7).map { o[rand(o.length)] }.join
           
           #add the new ticket
           OpenTicket.create(
                name: name,
                email: email,
                product: product,
                issue: issue,
                ticket_id: ticket_id
            )
            
            @new_ticket_id = ticket_id
            
            render 'ticket_opened'
        end
    end
end

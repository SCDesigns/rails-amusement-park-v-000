class Ride < ActiveRecord::Base
  belongs_to :users
  belongs_to :attractions

  def take_ride
  requirements
    if !tall_enough && !enough_tickets
      "Sorry. " + ticket_error + height_error
    elsif !tall_enough
      "Sorry. " + height_error
    elsif !enough_tickets
      "Sorry. " + ticket_error + height_error
    else
      begin_ride
    end
  end

  def begin_ride
    new_happiness = self.user.happiness + self.attraction.happiness_rating
    new_nausea = self.user.nausea + self.attraction.nausea_rating
    new_tickets =  self.user.tickets - self.attraction.tickets
    self.user.update(
      :happiness => new_happiness,
      :nausea => new_nausea,
      :tickets => new_tickets
    )
    "Thanks for riding the #{self.attraction.name}!"
  end


  def requirements
    tall_enough, enough_tickets = false
    if self.user.tickets < self.attraction.tickets
      enough_tickets = true
    end
    if self.user.height < self.attraction.min_height
      tall_enough = true
    end
  end

  def ticket_error
    "You do not have enough tickets the #{self.attraction.name}."
  end

  def height_error
    "You are not tall enough to ride the #{self.attraction.name}."
  end
end

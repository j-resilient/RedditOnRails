module Votable
    extend ActiveSupport::Concern

    included do
        def vote_sum
            self.votes.pluck(:value).sum
        end
    end
end
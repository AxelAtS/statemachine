require 'statemachine/proc_calling'

module StateMachine

  class State
    
    include ProcCalling
    
    attr_reader :id, :statemachine, :superstate
    attr_accessor :entry_action, :exit_action

    def initialize(id, superstate, state_machine)
      @id = id
      @superstate = superstate
      @statemachine = state_machine
      @transitions = {}
    end

    def add(transition)
      @transitions[transition.event] = transition
    end
  
    def transitions
      return @superstate ? @transitions.merge(@superstate.transitions) : @transitions
    end
    
    def exit(args)
      @statemachine.trace("\texiting #{self}")
      call_proc(@exit_action, args, "exit action for #{self}") if @exit_action
      @superstate.substate_exiting(self) if @superstate
    end

    def enter(args)
      @statemachine.trace("\tentering #{self}")
      call_proc(@entry_action, args, "entry action for #{self}") if @entry_action
    end
    
    def activate
      @statemachine.state = self
    end
    
    def is_concrete?
      return true
    end

    def to_s
      return "'#{id}' state"
    end

  end
  
end
from abc import ABC, abstractmethod


class IPrompt(ABC):
    """Prompt interface."""

    @abstractmethod
    def run(self) -> None:
        """Run the prompt loop."""

        raise NotImplementedError

from qibolab import Config, ExecutionParameters, ParallelSweepers, PulseSequence, Result
from qibolab._core.instruments.abstract import Controller

__all__ = ["QuantifyCoordinator"]


class QuantifyCoordinator(Controller):
    bounds: str = "quantify/bounds"

    @property
    def sampling_rate(self) -> int:
        return 1

    def connect(self):
        pass

    def disconnect(self):
        pass

    def play(
        self,
        configs: dict[str, Config],
        sequences: list[PulseSequence],
        options: ExecutionParameters,
        sweepers: list[ParallelSweepers],
    ) -> dict[int, Result]:
        return {}

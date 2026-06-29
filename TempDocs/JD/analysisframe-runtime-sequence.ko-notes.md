# AnalysisFrame Runtime Sequence Diagram

이 그림은 UML 구조와 Mapping View가 runtime에서 어떻게 생성, 전달, 소비되는지 보여준다.

근거 파일:

- `D:\swa\TimeGrapher-Net\src\TimeGrapher.Core\Analysis\AnalysisWorker.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.App\Views\MainWindow.axaml.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.App\Services\AnalysisFrameRenderScheduler.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.App\Services\AnalysisFramePresenter.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.App\Tabs\AnalysisFrameRouter.cs`
- `D:\swa\TimeGrapher-Net\src\TimeGrapher.App\Tabs\IAnalysisFrameConsumer.cs`

발표 포인트:

- `AnalysisWorker`가 같은 analysis pass의 결과를 `AnalysisFrame` 하나로 묶어 발행한다.
- `AnalysisFrameRenderScheduler`가 latest-wins 방식으로 UI update cadence를 관리한다.
- `AnalysisFrameRouter`는 모든 consumer에게 `ObserveFrame(frame)`을 호출하고, active tab에만 `RenderFrame(frame, context)`를 호출한다.
- Renderer들은 Core를 다시 호출하지 않고 같은 frame snapshot을 소비한다.

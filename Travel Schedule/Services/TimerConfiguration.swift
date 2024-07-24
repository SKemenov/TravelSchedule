//
//  TimerConfiguration.swift
//  Travel Schedule
//
//  Created by Sergey Kemenov on 04.06.2024.
//

import Foundation

struct TimerConfiguration {
    // MARK: - Constants
    let pagesCount: Int
    let timerTickInternal: TimeInterval
    let progressPerTick: CGFloat

    // MARK: - Inits
    init(
        pagesCount: Int,
        secondsPerStory: TimeInterval = 5,
        timerTickInternal: TimeInterval = 0.25
    ) {
        self.pagesCount = pagesCount
        self.timerTickInternal = timerTickInternal
        self.progressPerTick = 1.0 / CGFloat(pagesCount) / secondsPerStory * timerTickInternal
    }

    // MARK: - Methods
    func progress(for storyIndex: Int) -> CGFloat {
        min(CGFloat(storyIndex) / CGFloat(pagesCount), 1)
    }

    func index(for progress: CGFloat) -> Int {
        min(Int(progress * CGFloat(pagesCount)), pagesCount - 1)
    }

    func nextProgress(progress: CGFloat) -> CGFloat {
        min(progress + progressPerTick, 1)
    }
}
